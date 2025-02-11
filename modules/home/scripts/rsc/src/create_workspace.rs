use std::{env, fs};
use std::process::{Command, Stdio};

use crate::utils::*;

const WORKSPACE_PARENT: &str = "Desktop/Workspaces";

pub fn create_workspace(name: &str, template: Option<&str>) {
    let new_workspace = home_dir()
        .join(WORKSPACE_PARENT)
        .join(name);

    print_step(format!("Creating new workspace directory \"{}\"", new_workspace.to_string_lossy()));
    fs::create_dir_all(&new_workspace)
        .expect("Unable to create workspace directory");

    if let Some(template) = template {
        print_step(format!("Initializing with flake template \"{}\"", template));
        env::set_current_dir(&new_workspace)
            .expect("Unable to switch working directory");
        Command::new("nix")
            .args(["flake", "init", "-t", &format!("templates#{}", template)])
            .status()
            .expect("Unable to init nix flake");
    }



    print_done();

    println!("{}", new_workspace.to_string_lossy());
}
