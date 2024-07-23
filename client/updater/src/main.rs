#[macro_use]
extern crate log;
extern crate simplelog;

mod backend;
mod frontend;
mod localizer;
mod version;

use std::env;
use std::error;
use std::fs::{self, File};
use std::path::Path;
use std::process;

use clap::Parser;
use simplelog::*;
use tokio;

use backend::updater::update;
use frontend::app::Updater;
use localizer::{Key, Localizer};
use version::Version;

#[macro_export]
macro_rules! panic_with_log {
    ($($arg: tt)*) => {
        error!($($arg)*);
        panic!($($arg)*);
    };
}

pub const PACK_IMAGE: &[u8] = include_bytes!("../assets/pack.png");
const LOG_PATH: &str = "naangiskhan-logs/updater.log";

#[derive(Debug, Parser)]
#[clap(
    name = env!("CARGO_PKG_NAME"),
    version = env!("CARGO_PKG_VERSION"),
    author = env!("CARGO_PKG_AUTHORS"),
    about = env!("CARGO_PKG_DESCRIPTION"),
)]
struct Args {
    #[arg(index = 1,
          value_parser = Version::from_str,
          help = Localizer::get(&Key::CommandLineArgCurrentVersion))]
    current_version: Option<Version>,

    #[arg(long, help = Localizer::get(&Key::CommandLineArgIsAutoStart))]
    is_auto_start: bool,

    #[arg(long, help = Localizer::get(&Key::CommandLineArgIsNoGui))]
    is_no_gui: bool,
}

fn initialize_logger(path: &str) -> Result<(), Box<dyn error::Error>> {
    let log_path = Path::new(path);
    // ログファイルまでのディレクトリを作成
    fs::create_dir_all(
        log_path
            .parent()
            .ok_or("Failed to get log file parent path.")?,
    )?;
    // ログファイルの作成 && ロガーの初期化
    WriteLogger::init(
        LevelFilter::Info,
        Config::default(),
        File::create(log_path)?,
    )?;
    Ok(())
}

#[tokio::main]
async fn main() {
    // ロガーの初期化
    if let Err(e) = initialize_logger(LOG_PATH) {
        error!("Failed to initialize logger: {:?}", e);
        process::exit(1);
    }

    let args = Args::parse();
    if !args.is_no_gui {
        match Updater::start(args.current_version, args.is_auto_start) {
            Ok(_) => {
                // TODO: インストーラを取り込むまでの一時措置
                // info!("GUI Updater finished successfully.");
                warn!("GUI Updater is interrupted.");
                process::exit(1);
            }
            Err(e) => {
                error!("GUI Updater failed: {}", e);
                process::exit(1);
            }
        }
    } else {
        match update(
            args.current_version,
            |message_key, message_params, sub_message_key, _, _| {
                if let Some(key) = message_key {
                    if key != Key::Empty {
                        println!("{}", Localizer::get_with_params(&key, &message_params));
                    }
                }
                if let Some(res) = sub_message_key {
                    match res {
                        Ok(key) => {
                            if key != Key::Empty {
                                println!("{}", Localizer::get(&key))
                            }
                        }
                        Err(key) => {
                            if key != Key::Empty {
                                eprintln!("{}", Localizer::get(&key))
                            }
                        }
                    }
                }
            },
        )
        .await
        {
            Ok(_) => {
                info!("CLI Updater finished successfully.");
                println!("{}", Localizer::get(&Key::UpdaterSceneUpdateFinished));
            }
            Err(e) => {
                error!("CLI Updater failed: {}", e);
                process::exit(1);
            }
        }
    }
}
