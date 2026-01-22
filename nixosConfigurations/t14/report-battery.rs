use std::time::{Duration, SystemTime, UNIX_EPOCH};
use std::{env, fs, process};
use std::path::PathBuf;

struct PowerSupply(String, PathBuf);

const POWER_SUPPLY_CLASS_PATH: &str = "/sys/class/power_supply";
const TMPFILE: &str = "/tmp/report-battery.dat";


impl PowerSupply {
    fn new(name: String) -> Result<Self, String> {
        let path = PathBuf::from(POWER_SUPPLY_CLASS_PATH).join(&name);
        if !path.exists() {
            Err(format!("Power supply does not exist: {}", path.to_string_lossy()))
        } else {
            Ok(PowerSupply(name, path))
        }
    }

    fn all() -> Result<Vec<Self>, String> {
        let mut v = Vec::new();
        for result in fs::read_dir(POWER_SUPPLY_CLASS_PATH).map_err(|e| e.to_string())? {
            let child = result.map_err(|e| e.to_string())?;
            v.push(PowerSupply::new(child.file_name().to_string_lossy().to_string())?);
        }
        v.sort_by_key(|s| s.name().to_string());
        Ok(v)
    }

    fn name(&self) -> &str {
        &self.0
    }

    fn path(&self) -> &PathBuf {
        &self.1
    }

    fn is_battery(&self) -> bool {
        self.name().starts_with("BAT")
    }

    fn is_online(&self) -> Result<bool, String> {
        let file = self.path().join("online");
        let s = fs::read_to_string(&file)
            .map_err(|e| e.to_string())?;
        let u: u64 = s.trim().parse()
            .map_err(|_| format!("Unable to parse contents of {}", file.to_string_lossy()))?;
        Ok(u == 1)
    }

    fn energy_now(&self) -> Result<u64, String> {
        let file = self.path().join("energy_now");
        let s = fs::read_to_string(&file)
            .map_err(|e| e.to_string())?;
        let u: u64 = s.trim().parse()
            .map_err(|_| format!("Unable to parse contents of {}", file.to_string_lossy()))?;
        Ok(u / 1000)
    }

    fn energy_full(&self) -> Result<u64, String> {
        let file = self.path().join("energy_full");
        let s = fs::read_to_string(&file)
            .map_err(|e| e.to_string())?;
        let u: u64 = s.trim().parse()
            .map_err(|_| format!("Unable to parse contents of {}", file.to_string_lossy()))?;
        Ok(u / 1000)  // mWh
    }
}

fn report_current_source(power_supplies: &[PowerSupply]) {
    if power_supplies.iter().any(|s| !s.is_battery() && s.is_online().unwrap_or_default()) {
        println!("Currently running on mains");
    } else {
        println!("Currently running on battery power");
    }
}

fn store(seconds: u64, energy: u64) -> Result<(), String> {
    let data = format!("{}\n{}\n", seconds, energy);
    fs::write(TMPFILE, data.bytes().collect::<Vec<_>>())
        .map_err(|e| e.to_string())
}

fn load() -> Result<(u64, u64), String> {
    let data = fs::read_to_string(TMPFILE)
        .map_err(|e| e.to_string())?;
    let mut lines = data.lines();
    let time_str = lines.next()
        .ok_or(String::from("Invalid save format"))?;
    let energy_str = lines.next()
        .ok_or(String::from("Invalid save format"))?;
    let time: u64 = time_str.parse()
        .map_err(|_| String::from("Invalid save format"))?;
    let energy: u64 = energy_str.parse()
        .map_err(|_| String::from("Invalid save format"))?;
    fs::remove_file(TMPFILE)
        .map_err(|_| String::from("Unable to delete temp file"))?;
    Ok((time, energy))
}

fn run_pre() -> Result<(), String> {
    let power_supplies = PowerSupply::all()?;
    let battery = power_supplies.iter()
        .find(|b| b.is_battery())
        .ok_or(String::from("No battery found"))?;
    if power_supplies.iter().filter(|s| s.is_battery()).count() > 1 {
        eprintln!("Warning: Multiple batteries are not supported, considering only {}", battery.name());
    }
    report_current_source(&power_supplies);

    let time = SystemTime::now();
    let epoch_seconds = time.duration_since(UNIX_EPOCH)
        .map_err(|e| e.to_string())?
        .as_secs();
    let energy_now = battery.energy_now()?;

    println!("Saving time and battery energy to {} before sleeping.", TMPFILE);
    store(epoch_seconds, energy_now)
}

fn run_post() -> Result<(), String> {
    let power_supplies = PowerSupply::all()?;
    let battery = power_supplies.iter()
        .find(|b| b.is_battery())
        .ok_or(String::from("No battery found"))?;
    if power_supplies.iter().filter(|s| s.is_battery()).count() > 1 {
        eprintln!("Warning: Multiple batteries are not supported, considering only {}", battery.name());
    }

    let (time_prev, energy_prev) = load()?;
    let time_prev = UNIX_EPOCH + Duration::from_secs(time_prev);
    let time_diff = time_prev.elapsed()
        .map_err(|e| e.to_string())?;
    let seconds = time_diff.as_secs() % 60;
    let minutes = time_diff.as_secs() / 60 % 60;
    let hours = time_diff.as_secs() / 3600 % 24;
    let days = time_diff.as_secs() / (24 * 3600);
    println!("Slept for {} days, {} hours, {} minutes, {} seconds", days, hours, minutes, seconds);

    let energy_full = battery.energy_full()? as f64;
    let energy_diff = energy_prev - battery.energy_now()?;
    let avg_rate = energy_diff * 3600 / time_diff.as_secs();
    let energy_diff_pct = energy_diff as f64 * 100.0 / energy_full;
    let avg_rate_pct = avg_rate as f64 * 100.0 / energy_full;

    println!("Battery energy change of {:.2}% ({} mWh) at an average rate of {:.2}%/h ({} mW).",
        energy_diff_pct, energy_diff,
        avg_rate_pct, avg_rate);

    Ok(())
}

fn main() {
    let args = env::args().collect::<Vec<_>>();
    let args_str = args.iter().map(|s| s.as_str()).collect::<Vec<_>>();
    let result = match &args_str.as_slice() {
        &[_, "pre"] => run_pre(),
        &[_, "post"] => run_post(),
        &[name, ..] => Err(format!("Usage: {} pre|post", name)),
        _ => Err(String::from("Usage: report-battery pre|post")),
    };

    match result {
        Ok(_) => (),
        Err(e) => {
            eprintln!("Error: {}", e);
            process::exit(1);
        },
    }
}
