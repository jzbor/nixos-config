use std::env;
use std::fmt::Display;
use std::path::{Path, PathBuf};

use colored::*;

pub fn print_step(s: impl Display) {
    let t = format!("-> {}", s).cyan();
    eprintln!("\n{}", t);
}

pub fn print_done() {
    let t = "DONE".green();
    eprintln!("\n{}", t);
}


pub fn home_dir() -> PathBuf {
    Path::new(
        &env::var("HOME")
            .expect("Unable to read $HOME variable")
    ).to_owned()
}
