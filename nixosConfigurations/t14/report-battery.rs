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
        let u: i64 = s.trim().parse()
            .map_err(|_| format!("Unable to parse contents of {}", file.to_string_lossy()))?;
        Ok(u == 1)
    }

    fn energy_now(&self) -> Result<i64, String> {
        let file = self.path().join("energy_now");
        let s = fs::read_to_string(&file)
            .map_err(|e| e.to_string())?;
        let u: i64 = s.trim().parse()
            .map_err(|_| format!("Unable to parse contents of {}", file.to_string_lossy()))?;
        Ok(u / 1000)
    }

    fn energy_full(&self) -> Result<i64, String> {
        let file = self.path().join("energy_full");
        let s = fs::read_to_string(&file)
            .map_err(|e| e.to_string())?;
        let u: i64 = s.trim().parse()
            .map_err(|_| format!("Unable to parse contents of {}", file.to_string_lossy()))?;
        Ok(u / 1000)  // mWh
    }
}

fn pc10_residency() -> Result<i64, String> {
    let file = PathBuf::from("/sys/devices/system/cpu/cpuidle/low_power_idle_cpu_residency_us");
    let s = fs::read_to_string(&file)
        .map_err(|e| e.to_string())?;
    let u: i64 = s.trim().parse()
        .map_err(|_| format!("Unable to parse contents of {}", file.to_string_lossy()))?;
    Ok(u / 1_000_000)  // sec
}

fn slp_s0_residency() -> Result<i64, String> {
    let file = PathBuf::from("/sys/devices/system/cpu/cpuidle/low_power_idle_system_residency_us");
    let s = fs::read_to_string(&file)
        .map_err(|e| e.to_string())?;
    let u: i64 = s.trim().parse()
        .map_err(|_| format!("Unable to parse contents of {}", file.to_string_lossy()))?;
    Ok(u / 1_000_000)  // sec
}

fn report_current_source(power_supplies: &[PowerSupply]) {
    if power_supplies.iter().any(|s| !s.is_battery() && s.is_online().unwrap_or_default()) {
        println!("Currently running on mains");
    } else {
        println!("Currently running on battery power");
    }
}

<<<<<<< HEAD
fn total_energy_now(power_supplies: &[PowerSupply]) -> Result<u64, String> {
    let sum = power_supplies.iter()
        .filter(|s| s.is_battery())
        .map(|b| b.energy_now())
        .collect::<Result<Vec<_>, String>>()?
        .into_iter()
        .sum();
    Ok(sum)
}

fn total_energy_full(power_supplies: &[PowerSupply]) -> Result<u64, String> {
    let sum = power_supplies.iter()
        .filter(|s| s.is_battery())
        .map(|b| b.energy_full())
        .collect::<Result<Vec<_>, String>>()?
        .into_iter()
        .sum();
    Ok(sum)
}

fn store(seconds: u64, energy: u64) -> Result<(), String> {
    let data = format!("{}\n{}\n", seconds, energy);
=======
fn store(seconds: i64, energy: i64, pc10: i64, slp_s0: i64) -> Result<(), String> {
    let data = format!("{}\n{}\n{}\n{}\n", seconds, energy, pc10, slp_s0);
>>>>>>> 31ef6dd (Updating scripts)
    fs::write(TMPFILE, data.bytes().collect::<Vec<_>>())
        .map_err(|e| e.to_string())
}

fn load() -> Result<(i64, i64, i64, i64), String> {
    let data = fs::read_to_string(TMPFILE)
        .map_err(|e| e.to_string())?;
    let mut lines = data.lines();
    let time_str = lines.next()
        .ok_or(String::from("Invalid save format"))?;
    let energy_str = lines.next()
        .ok_or(String::from("Invalid save format"))?;
    let pc10_str = lines.next()
        .ok_or(String::from("Invalid save format"))?;
    let slp_s0_str = lines.next()
        .ok_or(String::from("Invalid save format"))?;
    let time: i64 = time_str.parse()
        .map_err(|_| String::from("Invalid save format"))?;
    let energy: i64 = energy_str.parse()
        .map_err(|_| String::from("Invalid save format"))?;
    let pc10: i64 = pc10_str.parse()
        .map_err(|_| String::from("Invalid save format"))?;
    let slp_s0: i64 = slp_s0_str.parse()
        .map_err(|_| String::from("Invalid save format"))?;
    fs::remove_file(TMPFILE)
        .map_err(|_| String::from("Unable to delete temp file"))?;
    Ok((time, energy, pc10, slp_s0))
}

fn format_duration(d: Duration) -> String {
    let seconds = d.as_secs() % 60;
    let minutes = d.as_secs() / 60 % 60;
    let hours = d.as_secs() / 3600 % 24;
    let days = d.as_secs() / (24 * 3600);
    format!("{} days, {} hours, {} minutes, {} seconds", days, hours, minutes, seconds)
}

fn run_pre() -> Result<(), String> {
    let power_supplies = PowerSupply::all()?;
    power_supplies.iter()
        .find(|b| b.is_battery())
        .ok_or(String::from("No battery found"))?;
    report_current_source(&power_supplies);

    let time = SystemTime::now();
    let epoch_seconds = time.duration_since(UNIX_EPOCH)
        .map_err(|e| e.to_string())?
<<<<<<< HEAD
        .as_secs();
    let energy_now = total_energy_now(&power_supplies)?;
=======
        .as_secs() as i64;
    let energy_now = battery.energy_now()?;
>>>>>>> 31ef6dd (Updating scripts)

    let pc10 = pc10_residency()?;
    let slp_s0 = slp_s0_residency()?;

    println!("Saving time and battery energy to {} before sleeping.", TMPFILE);
    store(epoch_seconds, energy_now, pc10, slp_s0)
}

fn run_post() -> Result<(), String> {
    let power_supplies = PowerSupply::all()?;
    power_supplies.iter()
        .find(|b| b.is_battery())
        .ok_or(String::from("No battery found"))?;

    let (time_prev, energy_prev, pc10_prev, slp_s0_prev) = load()?;
    let time_prev = UNIX_EPOCH + Duration::from_secs(time_prev as u64);
    let time_diff = time_prev.elapsed()
        .map_err(|e| e.to_string())?;
    if time_diff.as_secs() == 0 {
        return Err(String::from("Slept to short to make a report."));
    }
    println!("Slept for {}", format_duration(time_diff));

    let energy_full = battery.energy_full()? as f64;
    let energy_now = battery.energy_now()?;
    let energy_diff = energy_prev - energy_now;
    let avg_rate = energy_diff * 3600 / time_diff.as_secs() as i64;
    let energy_diff_pct = energy_diff as f64 * 100.0 / energy_full;
    let avg_rate_pct = avg_rate as f64 * 100.0 / energy_full;

    let pc10_now = pc10_residency()?;
    let slp_s0_now = slp_s0_residency()?;
    let pc10_time = Duration::from_secs((pc10_now - pc10_prev) as u64);
    let slp_s0_time = Duration::from_secs((slp_s0_now - slp_s0_prev) as u64);

    if energy_now > energy_prev {
        println!("Battery charged by {:.2}% ({} mWh) during sleep.",
            -energy_diff_pct, -energy_diff)
    } else {
        println!("Battery energy change of {:.2}% ({} mWh) at an average rate of {:.2}%/h ({} mW).",
            energy_diff_pct, energy_diff,
            avg_rate_pct, avg_rate);
    }

    let pc10_pct = pc10_time.as_secs() as f64 * 100.0 / time_diff.as_secs() as f64;
    let slp_s0_pct = slp_s0_time.as_secs() as f64 * 100.0 / time_diff.as_secs() as f64;
    println!("CPU spent {} ({:.2}%) in PC10", format_duration(pc10_time), pc10_pct);
    println!("System spent {} ({:.2}%) in SLP_S0", format_duration(slp_s0_time), slp_s0_pct);

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
