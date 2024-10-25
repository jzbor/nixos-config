use clap::Parser;
use create_workspace::create_workspace;

mod create_workspace;
mod utils;

/// jzbor's personal Rust script collection
#[derive(Parser)]
#[clap(author, version, about, long_about = None)]
struct Args {
    #[clap(subcommand)]
    command: Command,
}

#[derive(Clone, Debug, PartialEq, clap::Subcommand)]
enum Command {
    /// List all available commands
    CreateWorkspace {
        /// New workspace name
        name: String,

        /// Nix flake template to initialize with
        #[clap(short, long)]
        template: Option<String>,
    },
}

fn main() {
    let args = Args::parse();

    use Command::*;
    match &args.command {
        CreateWorkspace { name, template } => create_workspace(name, template.as_deref()),
    }
}
