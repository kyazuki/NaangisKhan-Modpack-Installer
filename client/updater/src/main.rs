#[macro_use]
extern crate log;
extern crate simplelog;

mod app;
mod updater;
mod version;

use std::env;
use std::error;
use std::fs::{self, File};
use std::path::Path;
use std::process;

use simplelog::*;

use app::Updater;
use updater::update;
use version::Version;

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

pub fn main() {
    // ロガーの初期化
    if let Err(e) = initialize_logger("naangiskhan-logs/updater.log") {
        error!("Failed to initialize logger: {:?}", e);
        process::exit(1);
    }

    // バージョン引数のパース
    let args: Vec<String> = env::args().collect();
    let mut is_no_gui = false;
    let mut version: Option<Version> = None;
    if args.len() >= 2 {
        for arg in &args[1..] {
            if arg == "--nogui" {
                is_no_gui = true;
            } else {
                match arg.as_str().try_into() {
                    Ok(v) => {
                        version = Some(v);
                    }
                    Err(e) => {
                        error!("Invalid version number: {:?}", e);
                        process::exit(1);
                    }
                }
            }
        }
    }
    if !is_no_gui {
        match Updater::start() {
            Ok(_) => {
                info!("GUI Updater finished successfully.");
            }
            Err(e) => {
                error!("GUI Updater failed: {}", e);
                process::exit(1);
            }
        }
    } else {
        match update(version) {
            Ok(_) => {
                info!("CLI Updater finished successfully.");
            }
            Err(e) => {
                error!("CLI Updater failed: {}", e);
                process::exit(1);
            }
        }
    }
}
