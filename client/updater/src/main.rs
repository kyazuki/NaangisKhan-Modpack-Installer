#[macro_use]
extern crate log;
extern crate simplelog;

mod version;

use std::fs::{self, File};
use std::io::{BufRead, BufReader, ErrorKind, Write};
use std::path::Path;
use std::process;
use std::{env, io};
use std::{error, vec};

use simplelog::*;

use version::Version;

const LATEST_VERSION: Version = Version::new(1, 1, 6);

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

fn download_file(path: &str, url: &str, is_force: bool) -> Result<(), Box<dyn error::Error>> {
    let path = Path::new(path);
    if path.is_dir() {
        return Err(Box::new(io::Error::new(
            ErrorKind::Other,
            format!("Invalid path: {:?}", path),
        )));
    }
    match !is_force && path.try_exists()? {
        true => {
            info!("File is already exists: {:?}", path);
        }
        false => {
            info!("Downloading: {:?} -> {:?}", url, path.display());
            let response = reqwest::blocking::get(url)?;
            if !response.status().is_success() {
                return Err(Box::new(io::Error::new(
                    ErrorKind::Other,
                    format!("Failed to download: {:?}", response.status()),
                )));
            }
            let temp_path = path
                .parent()
                .unwrap_or_else(|| Path::new(""))
                .join("download.tmp");
            let temp_path = temp_path.as_path();
            let mut file = File::create(temp_path)?;
            file.write_all(&response.bytes()?)?;
            fs::rename(temp_path, path)?;
        }
    }
    Ok(())
}

fn download_curseforge_file(
    path: &str,
    project_id: u32,
    file_id: u32,
    is_force: bool,
) -> Result<(), Box<dyn error::Error>> {
    let url = format!(
        "https://www.curseforge.com/api/v1/mods/{}/files/{}/download",
        project_id, file_id
    );
    download_file(path, &url, is_force)
}

fn remove_file_if_exist(path: &str) -> Result<(), io::Error> {
    info!("Removing: {:?}", path);
    let path = Path::new(path);
    if let Err(e) = fs::remove_file(path) {
        if e.kind() != ErrorKind::NotFound {
            return Err(e);
        }
    }

    Ok(())
}

fn is_old_version(now: &Option<Version>, version: &Version) -> bool {
    match now {
        Some(v) => v.is_old(version),
        None => true,
    }
}

fn updater(version: Option<Version>) -> Result<(), Box<dyn error::Error>> {
    let is_force_update = version.is_none();
    if !is_force_update {
        info!("Starting update...");
        println!("アップデートを開始します...");
    } else {
        info!("Starting force update...");
        println!("強制アップデートを開始します...");
    }
    // 旧リソースパックが残っていれば削除
    let mut is_old_resource = false;
    let old_packs = vec!["resourcepacks/NaangisKhan", "resourcepacks/Naan.zip"];
    for pack in old_packs {
        let path = Path::new(pack);
        match path.try_exists() {
            Ok(false) => {}
            Ok(true) => {
                info!("Found old resource pack: {:?}", path);
                is_old_resource = true;
                if path.is_dir() {
                    fs::remove_dir_all(path).unwrap_or_else(|e| {
                        warn!("Failed to remove old resource pack: {:?}", e);
                    });
                } else {
                    fs::remove_file(path).unwrap_or_else(|e| {
                        warn!("Failed to remove old resource pack: {:?}", e);
                    });
                }
            }
            Err(e) => {
                warn!("Failed to check if old resource pack exists: {:?}", e);
            }
        }
    }
    if is_old_resource {
        // 旧仕様であればリソースパックの設定を差し替える
        let path = "options.txt";
        let mut new_options_txt = String::new();
        match File::open(&path) {
            Ok(file) => {
                for result in BufReader::new(file).lines() {
                    let line = result?;
                    if line.starts_with("resourcePacks:") {
                        new_options_txt.push_str("resourcePacks:[");
                        for pack in line[15..(line.len() - 1)].split(",") {
                            let pack = pack.trim();
                            if pack != "\"NaangisKhan\"" && pack != "\"Naan.zip\"" {
                                // 'Naangiskhan'と'Naan.zip'を除き追加
                                new_options_txt.push_str(pack);
                                new_options_txt.push_str(",");
                            }
                        }
                        // 'NaangisKhan.zip'を末尾(優先度最高)に追加
                        new_options_txt.push_str("\"file/NaangisKhan.zip\"");
                        new_options_txt.push_str("]\n");
                    } else {
                        new_options_txt.push_str(&line);
                        new_options_txt.push_str("\n");
                    }
                }
                let tmp_path = format!("{}.tmp", &path);
                match File::create(&tmp_path) {
                    Ok(mut file) => {
                        info!("Created {:?}.", &tmp_path);
                        write!(file, "{}", new_options_txt)?;
                        file.flush()?;
                        fs::rename(&tmp_path, &path)?;
                        info!("Updated {:?}.", &path);
                        println!("設定ファイルを更新しました。");
                    }
                    Err(e) => {
                        error!("Failed to create {:?}: {:?}", &tmp_path, e);
                        eprintln!("設定ファイルの更新に失敗しました。");
                    }
                }
            }
            Err(e) => {
                error!("Failed to open {:?}: {:?}", &path, e);
                eprintln!("設定ファイルが存在しません。");
            }
        };
    }

    // リソースパックを更新
    if is_old_version(&version, &LATEST_VERSION) {
        println!("リソースパックを更新中...");
        download_file("resourcepacks/NaangisKhan.zip", &format!("https://github.com/kyazuki/NaangisKhan-Modpack-Installer/releases/download/v{}/NaangisKhan.zip", &LATEST_VERSION), is_force_update)?;
    }

    // マイグレーション処理
    // v1.0.15アップデート
    if is_old_version(&version, &"1.0.15".try_into()?) {
        info!("Starting migration for v1.0.15...");
        println!("v1.0.15アップデートの適用を開始します...");
        println!("追加Modをインストール中...");
        download_curseforge_file(
            "mods/polymorph-forge-0.49.2+1.20.1.jar",
            388800,
            4928442,
            is_force_update,
        )?;
    }
    // v1.1.0アップデート
    if is_old_version(&version, &"1.1.0".try_into()?) {
        info!("Starting migration for v1.1.0...");
        println!("v1.1.0アップデートの適用を開始します...");
        // Maturi Delightを削除
        remove_file_if_exist("mods/maturidelight-1.20.1-3.0.0.jar")?;
        println!("Modをアップデート中...");
        remove_file_if_exist("mods/handcrafted-forge-1.20.1-3.0.5.jar")?;
        download_curseforge_file(
            "mods/handcrafted-forge-1.20.1-3.0.6.jar",
            538214,
            5118729,
            is_force_update,
        )?;
        remove_file_if_exist("mods/supplementaries-1.20-2.7.35.jar")?;
        download_curseforge_file(
            "mods/supplementaries-1.20-2.8.6.jar",
            412082,
            5154529,
            is_force_update,
        )?;
        remove_file_if_exist("mods/ars_creo-1.20.1-4.0.1.jar")?;
        download_curseforge_file(
            "mods/ars_creo-1.20.1-4.1.0.jar",
            575698,
            5171755,
            is_force_update,
        )?;
        remove_file_if_exist("mods/TofuCraftReload-1.20.1-5.9.0.1.jar")?;
        download_curseforge_file(
            "mods/TofuCraftReload-1.20.1-5.10.4.1.jar",
            317469,
            5181742,
            is_force_update,
        )?;
        remove_file_if_exist("mods/tofucreate-1.20.1-0.1.0.jar")?;
        download_curseforge_file(
            "mods/tofucreate-1.20.1-0.2.0.jar",
            924197,
            5109349,
            is_force_update,
        )?;
        remove_file_if_exist("mods/tofudelight-1.20.1-2.4.1.jar")?;
        download_curseforge_file(
            "mods/tofudelight-1.20.1-2.5.0.jar",
            835619,
            5112167,
            is_force_update,
        )?;
        remove_file_if_exist("mods/twilightdelight-2.0.4.jar")?;
        download_curseforge_file(
            "mods/twilightdelight-2.0.7.jar",
            871735,
            5116432,
            is_force_update,
        )?;
        remove_file_if_exist("mods/artifacts-forge-9.2.2.jar")?;
        download_curseforge_file(
            "mods/artifacts-forge-9.3.0.jar",
            312353,
            5152057,
            is_force_update,
        )?;
        remove_file_if_exist("mods/betterarcheology-1.1.5-1.20.1.jar")?;
        download_curseforge_file(
            "mods/betterarcheology-1.1.7-1.20.1.jar",
            835687,
            5158209,
            is_force_update,
        )?;
        remove_file_if_exist("mods/friendsandfoes-forge-mc1.20.1-2.0.9.jar")?;
        download_curseforge_file(
            "mods/friendsandfoes-forge-mc1.20.1-2.0.10.jar",
            602059,
            5184455,
            is_force_update,
        )?;
        remove_file_if_exist("mods/journeymap-1.20.1-5.9.18-forge.jar")?;
        download_curseforge_file(
            "mods/journeymap-1.20.1-5.9.18p1-forge.jar",
            32274,
            5157733,
            is_force_update,
        )?;
        remove_file_if_exist("mods/netherdepthsupgrade-3.1.3-1.20.jar")?;
        download_curseforge_file(
            "mods/netherdepthsupgrade-3.1.4-1.20.jar",
            670011,
            5150560,
            is_force_update,
        )?;
        remove_file_if_exist("mods/aether-redux-1.3.4-1.20.1-neoforge.jar")?;
        download_curseforge_file(
            "mods/aether-redux-2.0.6-1.20.1-neoforge.jar",
            867237,
            5173184,
            is_force_update,
        )?;
        remove_file_if_exist("mods/TheOuterEnd-1.0.4.jar")?;
        download_curseforge_file(
            "mods/TheOuterEnd-1.0.6.jar",
            430404,
            5158921,
            is_force_update,
        )?;
        remove_file_if_exist("mods/emi-1.1.1+1.20.1+forge.jar")?;
        download_curseforge_file(
            "mods/emi-1.1.3+1.20.1+forge.jar",
            580555,
            5172928,
            is_force_update,
        )?;
        remove_file_if_exist("mods/jei-1.20.1-forge-15.3.0.1.jar")?;
        download_curseforge_file(
            "mods/jei-1.20.1-forge-15.3.0.4.jar",
            238222,
            5101366,
            is_force_update,
        )?;
        remove_file_if_exist("mods/lightmanscurrency-1.20.1-2.2.0.3c.jar")?;
        download_curseforge_file(
            "mods/lightmanscurrency-1.20.1-2.2.1.0b.jar",
            472521,
            5127058,
            is_force_update,
        )?;
        remove_file_if_exist("mods/Quark-4.0-436.jar")?;
        download_curseforge_file("mods/Quark-4.0-438.jar", 243121, 5151658, is_force_update)?;
        remove_file_if_exist("mods/voicechat-forge-1.20.1-2.5.2.jar")?;
        download_curseforge_file(
            "mods/voicechat-forge-1.20.1-2.5.8.jar",
            416089,
            5164154,
            is_force_update,
        )?;
        remove_file_if_exist("mods/CraftTweaker-forge-1.20.1-14.0.33.jar")?;
        download_curseforge_file(
            "mods/CraftTweaker-forge-1.20.1-14.0.36.jar",
            239197,
            5137190,
            is_force_update,
        )?;
        remove_file_if_exist("mods/CreateTweaker-forge-1.20.1-4.0.7.jar")?;
        download_curseforge_file(
            "mods/CreateTweaker-forge-1.20.1-4.0.8.jar",
            437717,
            5116404,
            is_force_update,
        )?;
        remove_file_if_exist("mods/architectury-9.1.13-forge.jar")?;
        download_curseforge_file(
            "mods/architectury-9.2.14-forge.jar",
            419699,
            5137938,
            is_force_update,
        )?;
        remove_file_if_exist("mods/balm-forge-1.20.1-7.2.1.jar")?;
        download_curseforge_file(
            "mods/balm-forge-1.20.1-7.2.2.jar",
            531761,
            5140912,
            is_force_update,
        )?;
        remove_file_if_exist("mods/blueprint-1.20.1-7.0.0.jar")?;
        download_curseforge_file(
            "mods/blueprint-1.20.1-7.0.1.jar",
            382216,
            5147442,
            is_force_update,
        )?;
        remove_file_if_exist("mods/citadel-2.5.3-1.20.1.jar")?;
        download_curseforge_file(
            "mods/citadel-2.5.4-1.20.1.jar",
            331936,
            5143956,
            is_force_update,
        )?;
        remove_file_if_exist("mods/curios-forge-5.7.0+1.20.1.jar")?;
        download_curseforge_file(
            "mods/curios-forge-5.7.2+1.20.1.jar",
            309927,
            5175956,
            is_force_update,
        )?;
        remove_file_if_exist("mods/fusion-1.1.0c-forge-mc1.20.1.jar")?;
        download_curseforge_file(
            "mods/fusion-1.1.1-forge-mc1.20.1.jar",
            854949,
            5129294,
            is_force_update,
        )?;
        remove_file_if_exist("mods/moonlight-1.20-2.9.12-forge.jar")?;
        download_curseforge_file(
            "mods/moonlight-1.20-2.11.4-forge.jar",
            499980,
            5180872,
            is_force_update,
        )?;
        remove_file_if_exist("mods/YungsApi-1.20-Forge-4.0.3.jar")?;
        download_curseforge_file(
            "mods/YungsApi-1.20-Forge-4.0.4.jar",
            421850,
            5147001,
            is_force_update,
        )?;
        remove_file_if_exist("mods/Zeta-1.0-13.jar")?;
        download_curseforge_file("mods/Zeta-1.0-14.jar", 968868, 5151582, is_force_update)?;
        remove_file_if_exist("mods/craftingtweaks-forge-1.20-18.2.2.jar")?;
        download_curseforge_file(
            "mods/craftingtweaks-forge-1.20.1-18.2.3.jar",
            233071,
            5140224,
            is_force_update,
        )?;
        remove_file_if_exist("mods/embeddium-0.3.1+mc1.20.1.jar")?;
        download_curseforge_file(
            "mods/embeddium-0.3.9+mc1.20.1.jar",
            908741,
            5175031,
            is_force_update,
        )?;
        remove_file_if_exist("mods/oculus-mc1.20.1-1.6.15.jar")?;
        download_curseforge_file(
            "mods/oculus-mc1.20.1-1.6.15a.jar",
            581495,
            5108615,
            is_force_update,
        )?;
        remove_file_if_exist("mods/Tips-Forge-1.20.1-12.0.4.jar")?;
        download_curseforge_file(
            "mods/Tips-Forge-1.20.1-12.0.5.jar",
            306549,
            5134760,
            is_force_update,
        )?;
        println!("追加Modをインストール中...");
        download_curseforge_file(
            "mods/amendments-1.20-1.1.10.jar",
            896746,
            5176182,
            is_force_update,
        )?;
        download_curseforge_file(
            "mods/copperandtuffbackport-1.2.jar",
            950738,
            5081431,
            is_force_update,
        )?;
        download_curseforge_file(
            "mods/Copycats-forge.1.20.1-1.2.4.jar",
            968398,
            5187796,
            is_force_update,
        )?;
        download_curseforge_file(
            "mods/create_central_kitchen-1.20.1-for-create-0.5.1.f-1.3.10.jar",
            820977,
            5132704,
            is_force_update,
        )?;
        download_curseforge_file(
            "mods/Croptopia-1.20.1-FORGE-3.0.4.jar",
            415438,
            4997459,
            is_force_update,
        )?;
        download_curseforge_file(
            "mods/Delightful-1.20.1-3.5.2.jar",
            637529,
            5167936,
            is_force_update,
        )?;
        download_curseforge_file(
            "mods/ends_delight-1.20.1-1.0.1.jar",
            662675,
            4678069,
            is_force_update,
        )?;
        download_curseforge_file(
            "mods/miners_delight-1.20.1-1.2.3.jar",
            689630,
            5038950,
            is_force_update,
        )?;
        download_curseforge_file(
            "mods/oceansdelight-1.0.2-1.20.jar",
            841262,
            4652060,
            is_force_update,
        )?;
        download_curseforge_file(
            "mods/undergarden_delight_1.0.0_forge_1.20.1.jar",
            960662,
            5023548,
            is_force_update,
        )?;
        download_curseforge_file(
            "mods/backported_wolves-1.0.3-1.20.1.jar",
            984037,
            5166541,
            is_force_update,
        )?;
        download_curseforge_file(
            "mods/immersive_aircraft-0.7.5+1.20.1-forge.jar",
            666014,
            5168708,
            is_force_update,
        )?;
        download_curseforge_file(
            "mods/The_Undergarden-1.20.1-0.8.14.jar",
            379849,
            5182632,
            is_force_update,
        )?;
        download_curseforge_file(
            "mods/cosmeticarmorreworked-1.20.1-v1a.jar",
            237307,
            4600191,
            is_force_update,
        )?;
        download_curseforge_file(
            "mods/CuriosQuarkOBP-1.20.1-1.2.5.jar",
            445208,
            5085092,
            is_force_update,
        )?;
        download_curseforge_file(
            "mods/QuarkOddities-1.20.1.jar",
            301051,
            5070502,
            is_force_update,
        )?;
        download_curseforge_file(
            "mods/spyglass_of_curios-forge-1.20.1-1.7.2.jar",
            941332,
            5062462,
            is_force_update,
        )?;
        download_curseforge_file(
            "mods/EpheroLib-1.20.1-FORGE-1.2.0.jar",
            885449,
            4889101,
            is_force_update,
        )?;
        download_file("mods/naangiskhan-1.0.0+1.20.1.jar", "https://github.com/kyazuki/NaangisKhan-Modpack-Installer/releases/download/v1.1.0/naangiskhan-1.0.0+1.20.1.jar", is_force_update)?;
        println!("追加リソースパックをインストール中...");
        download_curseforge_file(
            "resourcepacks/Create Immersive Aircrafts Resource Pack 1.20.1 - 2.0.zip",
            821020,
            5096356,
            is_force_update,
        )?;
        download_curseforge_file(
            "resourcepacks/Nehter's_Delight_crops_3D_1.3.zip",
            965057,
            5122924,
            is_force_update,
        )?;
        {
            // リソースパックの設定を差し替える
            println!("リソースパックを整理中...");
            let path = "options.txt";
            let mut new_options_txt = String::new();
            match File::open(&path) {
                Ok(file) => {
                    let known_packs = vec![
                        "\"builtin/resource/overrides_pack\"",
                        "\"builtin/resource/redux_tips\"",
                        "\"file/Create Immersive Aircrafts Resource Pack 1.20.1 - 2.0.zip\"",
                        "\"file/Nehter\\u0027s_Delight_crops_3D_1.3.zip\"",
                        "\"file/NaangisKhan.zip\"",
                    ];
                    for result in BufReader::new(file).lines() {
                        let line = result?;
                        if line.starts_with("resourcePacks:") {
                            new_options_txt.push_str("resourcePacks:[");
                            for pack in line[15..(line.len() - 1)].split(",") {
                                let pack = pack.trim();
                                if !known_packs.contains(&pack) {
                                    // 'Naangiskhan'と'Naan.zip'を除き追加
                                    new_options_txt.push_str(pack);
                                    new_options_txt.push_str(",");
                                }
                            }
                            // 'NaangisKhan.zip'を末尾(優先度最高)に追加する
                            new_options_txt.push_str(&known_packs.join(","));
                            new_options_txt.push_str("]\n");
                        } else {
                            new_options_txt.push_str(&line);
                            new_options_txt.push_str("\n");
                        }
                    }
                    let tmp_path = format!("{}.tmp", &path);
                    match File::create(&tmp_path) {
                        Ok(mut file) => {
                            info!("Created {:?}.", &tmp_path);
                            write!(file, "{}", new_options_txt)?;
                            file.flush()?;
                            fs::rename(&tmp_path, &path)?;
                            info!("Updated {:?}.", &path);
                        }
                        Err(e) => {
                            error!("Failed to create {:?}: {:?}", &tmp_path, e);
                            eprintln!("設定ファイルの更新に失敗しました。");
                        }
                    }
                }
                Err(e) => {
                    error!("Failed to open {:?}: {:?}", &path, e);
                    eprintln!("設定ファイルが存在しません。");
                }
            };
        }
        {
            // タイトル画面で、Aetherのtoggle world/quick loadボタンを除去
            println!("エーテルの設定を変更中...");
            let path = "config/aether-client.toml";
            let mut new_aether_txt = String::new();
            match File::open(&path) {
                Ok(file) => {
                    for result in BufReader::new(file).lines() {
                        let line = result?;
                        if line.contains("Enables toggle world button")
                            || line.contains("Enables quick load button")
                        {
                            new_aether_txt.push_str(&line.replace("true", "false"));
                            new_aether_txt.push_str("\n");
                        } else {
                            new_aether_txt.push_str(&line);
                            new_aether_txt.push_str("\n");
                        }
                    }
                    let tmp_path = format!("{}.tmp", &path);
                    match File::create(&tmp_path) {
                        Ok(mut file) => {
                            info!("Created {:?}.", &tmp_path);
                            write!(file, "{}", new_aether_txt)?;
                            file.flush()?;
                            fs::rename(&tmp_path, &path)?;
                            info!("Updated {:?}.", &path);
                        }
                        Err(e) => {
                            error!("Failed to create {:?}: {:?}", &tmp_path, e);
                            eprintln!("設定ファイルの更新に失敗しました。");
                        }
                    }
                }
                Err(e) => {
                    error!("Failed to open {:?}: {:?}", &path, e);
                    eprintln!("エーテルの設定ファイルが見つかりません。");
                }
            };
        }
        {
            // Aether Reduxのタイトル画面変更を抑止
            println!("エーテル・リダックスの設定を変更中...");
            let path = "config/cumulus_menus-client.toml";
            let mut new_redux_txt = String::new();
            match File::open(&path) {
                Ok(file) => {
                    for result in BufReader::new(file).lines() {
                        let line = result?;
                        if line.contains("Enable Menu API") {
                            new_redux_txt.push_str(&line.replace("true", "false"));
                            new_redux_txt.push_str("\n");
                        } else {
                            new_redux_txt.push_str(&line);
                            new_redux_txt.push_str("\n");
                        }
                    }
                    let tmp_path = format!("{}.tmp", &path);
                    match File::create(&tmp_path) {
                        Ok(mut file) => {
                            info!("Created {:?}.", &tmp_path);
                            write!(file, "{}", new_redux_txt)?;
                            file.flush()?;
                            fs::rename(&tmp_path, &path)?;
                            info!("Updated {:?}.", &path);
                        }
                        Err(e) => {
                            error!("Failed to create {:?}: {:?}", &tmp_path, e);
                            eprintln!("エーテル・リダックスの設定の更新に失敗しました。");
                        }
                    }
                }
                Err(e) => {
                    error!("Failed to open {:?}: {:?}", &path, e);
                    eprintln!("タイトルメニューAPIの設定ファイルが見つかりません。");
                }
            };
        }
        {
            // Quarkのタイトル画面に表示されるqボタンのポップアップを抑制
            let path = ".qmenu_opened.marker";
            match Path::new(path).try_exists() {
                Ok(true) => {}
                Ok(false) => {
                    File::create(path)?;
                    info!("Created {:?}.", &path);
                }
                Err(e) => {
                    error!("Failed to check if {:?} exists: {:?}", &path, e);
                }
            }
        }
    }
    // v1.1.1アップデート
    if is_old_version(&version, &"1.1.1".try_into()?) {
        info!("Starting migration for v1.1.1...");
        println!("v1.1.1アップデートの適用を開始します...");
        println!("Modをアップデート中...");
        remove_file_if_exist("mods/naangiskhan-1.0.0+1.20.1.jar")?;
        download_file(
            "mods/naangiskhan-1.0.1+1.20.1.jar",
            "https://github.com/kyazuki/NaangisKhan-Modpack-Installer/releases/download/v1.1.1/naangiskhan-1.0.1+1.20.1.jar",
            is_force_update,
        )?;
    }
    // v1.1.2アップデート
    if is_old_version(&version, &"1.1.2".try_into()?) {
        info!("Starting migration for v1.1.2...");
        println!("v1.1.2アップデートの適用を開始します...");
        println!("追加Modをインストール中...");
        download_curseforge_file(
            "mods/emiffect-forge-1.1.2+mc1.20.1.jar",
            735528,
            4901311,
            is_force_update,
        )?;
    }
    // v1.1.3アップデート
    if is_old_version(&version, &"1.1.3".try_into()?) {
        info!("Starting migration for v1.1.3...");
        println!("v1.1.3アップデートの適用を開始します...");
        println!("Modをアップデート中...");
        remove_file_if_exist("mods/naangiskhan-1.0.1+1.20.1.jar")?;
        download_file(
            "mods/naangiskhan-1.1.0+1.20.1.jar",
            "https://github.com/kyazuki/NaangisKhan-Modpack-Installer/releases/download/v1.1.3/naangiskhan-1.1.0+1.20.1.jar",
            is_force_update,
        )?;
    }
    // v1.1.5アップデート
    if is_old_version(&version, &"1.1.5".try_into()?) {
        info!("Starting migration for v1.1.5...");
        println!("v1.1.5アップデートの適用を開始します...");
        println!("Modをアップデート中...");
        remove_file_if_exist("mods/naangiskhan-1.1.0+1.20.1.jar")?;
        download_file(
            "mods/naangiskhan-1.2.0+1.20.1.jar",
            "https://github.com/kyazuki/NaangisKhan-Modpack-Installer/releases/download/v1.1.5/naangiskhan-1.2.0+1.20.1.jar",
            is_force_update,
        )?;
        println!("追加Modをインストール中...");
        download_curseforge_file(
            "mods/ServerRedirect-ForgeMC20-1.4.5.jar",
            295232,
            4683939,
            is_force_update,
        )?;
        download_curseforge_file(
            "mods/simpleafk-1.1.2.jar",
            908384,
            5218384,
            is_force_update,
        )?;
        download_curseforge_file(
            "mods/watut-forge-1.20.1-1.1.1.jar",
            945479,
            5267703,
            is_force_update,
        )?;
        download_curseforge_file(
            "mods/coroutil-forge-1.20.1-1.3.7.jar",
            237749,
            5096038,
            is_force_update,
        )?;
    }
    // v1.1.6アップデート
    if is_old_version(&version, &"1.1.6".try_into()?) {
        info!("Starting migration for v1.1.6...");
        println!("v1.1.6アップデートの適用を開始します...");
        println!("Modをアップデート中...");
        remove_file_if_exist("mods/naangiskhan-1.2.0+1.20.1.jar")?;
        download_file(
            "mods/naangiskhan-1.2.1+1.20.1.jar",
            "https://github.com/kyazuki/NaangisKhan-Modpack-Installer/releases/download/v1.1.6/naangiskhan-1.2.1+1.20.1.jar",
            is_force_update,
        )?;
    }

    Ok(())
}

fn main() {
    // ロガーの初期化
    if let Err(e) = initialize_logger("naangiskhan-logs/updater.log") {
        error!("Failed to initialize logger: {:?}", e);
        process::exit(1);
    }

    // バージョン引数のパース
    let args: Vec<String> = env::args().collect();
    let mut version: Option<Version> = None;
    if args.len() >= 2 {
        let version_str: &str = &args[1];
        match version_str.try_into() {
            Ok(v) => {
                version = Some(v);
            }
            Err(e) => {
                error!("Invalid version number: {:?}", e);
                process::exit(1);
            }
        }
    }
    match updater(version) {
        Ok(_) => {
            info!("Updater finished successfully.");
        }
        Err(e) => {
            error!("Updater failed: {:?}", e);
            process::exit(1);
        }
    }
}
