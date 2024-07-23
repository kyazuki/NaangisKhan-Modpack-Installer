use std::fs::{self, File};
use std::io::{self, BufRead, BufReader, ErrorKind, Write};
use std::path::Path;
use std::time::Duration;
use std::vec;
use std::{error, thread};

use crate::localizer::Key;
use crate::version::Version;

const LATEST_VERSION: Version = Version::new(1, 2, 0);

async fn download_file(path: &str, url: &str, is_force: bool) -> Result<(), Box<dyn error::Error>> {
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
            let response = reqwest::get(url).await?;
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
            file.write_all(&response.bytes().await?)?;
            fs::rename(temp_path, path)?;
        }
    }
    Ok(())
}

async fn download_curseforge_file(
    path: &str,
    project_id: u32,
    file_id: u32,
    is_force: bool,
) -> Result<(), Box<dyn error::Error>> {
    let url = format!(
        "https://www.curseforge.com/api/v1/mods/{}/files/{}/download",
        project_id, file_id
    );
    download_file(path, &url, is_force).await
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

pub async fn update<F>(
    version: Option<Version>,
    notify_progress: F,
) -> Result<(), Box<dyn error::Error>>
where
    F: Fn(Option<Key>, Vec<String>, Option<Result<Key, Key>>, Option<String>, Option<f32>)
        + Send
        + 'static,
{
    let sleep = |sec: u64| {
        thread::sleep(Duration::from_secs(sec));
    };
    let print = |key: Key| {
        notify_progress(Some(key), vec![], None, None, None);
    };
    let print_fmt_with_sub = |key: Key, params: Vec<&str>, sub_key: Key| {
        notify_progress(
            Some(key),
            params.iter().map(|&str| str.to_string()).collect(),
            Some(Ok(sub_key)),
            None,
            None,
        );
    };
    let print_sub = |key: Key| {
        notify_progress(None, vec![], Some(Ok(key)), None, None);
    };
    let print_progress = |resource_name: &str, processed: i32, total: i32| {
        notify_progress(
            None,
            vec![],
            None,
            Some(resource_name.to_string()),
            Some(processed as f32 / total as f32 * 100.0),
        );
    };
    let print_progress_only = |processed: i32, total: i32| {
        notify_progress(
            None,
            vec![],
            None,
            None,
            Some(processed as f32 / total as f32 * 100.0),
        );
    };
    let end_progress = |processed: i32, total: i32| {
        debug_assert_eq!(processed, total);
        notify_progress(
            None,
            vec![],
            None,
            None,
            Some(processed as f32 / total as f32 * 100.0),
        );
    };
    let eprint_sub = |key: Key| {
        notify_progress(None, vec![], Some(Err(key)), None, None);
        sleep(3);
    };
    let reset_msg = || {
        notify_progress(
            Some(Key::Empty),
            vec![],
            Some(Ok(Key::Empty)),
            Some("".to_string()),
            None,
        );
    };
    let is_force_update = version.is_none();
    if !is_force_update {
        info!("Starting update...");
        print(Key::UpdaterSceneUpdateStart);
    } else {
        info!("Starting force update...");
        print(Key::UpdaterSceneUpdateStartForce);
    }
    sleep(2);
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
                        print_sub(Key::UpdaterSceneUpdateConfigFileSuccess);
                    }
                    Err(e) => {
                        error!("Failed to create {:?}: {:?}", &tmp_path, e);
                        eprint_sub(Key::UpdaterSceneUpdateConfigFileError);
                    }
                }
            }
            Err(e) => {
                error!("Failed to open {:?}: {:?}", &path, e);
                eprint_sub(Key::UpdaterSceneUpdateConfigFileNoExist);
            }
        };
    }

    reset_msg();
    // リソースパックを更新
    if is_old_version(&version, &LATEST_VERSION) {
        print(Key::UpdaterSceneUpdateResourcePack);
        download_file("resourcepacks/NaangisKhan.zip", &format!("https://github.com/kyazuki/NaangisKhan-Modpack-Installer/releases/download/v{}/NaangisKhan.zip", &LATEST_VERSION), true).await?;
    }

    // マイグレーション処理
    // v1.0.15アップデート
    if is_old_version(&version, &"1.0.15".try_into()?) {
        let total = 1;
        let mut processed = 0;
        info!("Starting migration for v1.0.15...");
        print_fmt_with_sub(Key::UpdaterSceneUpdateVersion, vec!["v1.0.15"], Key::Empty);
        print_sub(Key::UpdaterSceneUpdateModUpdate);
        print_progress("Polymorph", processed, total);
        download_curseforge_file(
            "mods/polymorph-forge-0.49.2+1.20.1.jar",
            388800,
            4928442,
            is_force_update,
        )
        .await?;
        processed += 1;
        end_progress(processed, total);
    }
    // v1.1.0アップデート
    if is_old_version(&version, &"1.1.0".try_into()?) {
        let total = 59;
        let mut processed = 0;
        info!("Starting migration for v1.1.0...");
        print_fmt_with_sub(Key::UpdaterSceneUpdateVersion, vec!["v1.1.0"], Key::Empty);
        // Maturi Delightを削除
        print_sub(Key::UpdaterSceneUpdateModRemove);
        print_progress("Maturi Delight", processed, total);
        remove_file_if_exist("mods/maturidelight-1.20.1-3.0.0.jar")?;
        processed += 1;
        print_progress("", processed, total);
        print_sub(Key::UpdaterSceneUpdateModUpdate);
        print_progress("Handcrafted", processed, total);
        remove_file_if_exist("mods/handcrafted-forge-1.20.1-3.0.5.jar")?;
        download_curseforge_file(
            "mods/handcrafted-forge-1.20.1-3.0.6.jar",
            538214,
            5118729,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Supplementaries", processed, total);
        remove_file_if_exist("mods/supplementaries-1.20-2.7.35.jar")?;
        // download_curseforge_file(
        //     "mods/supplementaries-1.20-2.8.6.jar",
        //     412082,
        //     5154529,
        //     is_force_update,
        // ).await?;
        processed += 1;
        print_progress("Ars Creo", processed, total);
        remove_file_if_exist("mods/ars_creo-1.20.1-4.0.1.jar")?;
        download_curseforge_file(
            "mods/ars_creo-1.20.1-4.1.0.jar",
            575698,
            5171755,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("TofuCraftReload", processed, total);
        remove_file_if_exist("mods/TofuCraftReload-1.20.1-5.9.0.1.jar")?;
        download_curseforge_file(
            "mods/TofuCraftReload-1.20.1-5.10.4.1.jar",
            317469,
            5181742,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("TofuCreate", processed, total);
        remove_file_if_exist("mods/tofucreate-1.20.1-0.1.0.jar")?;
        download_curseforge_file(
            "mods/tofucreate-1.20.1-0.2.0.jar",
            924197,
            5109349,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Tofu Delight", processed, total);
        remove_file_if_exist("mods/tofudelight-1.20.1-2.4.1.jar")?;
        download_curseforge_file(
            "mods/tofudelight-1.20.1-2.5.0.jar",
            835619,
            5112167,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Twilight's Flavors & Delight", processed, total);
        remove_file_if_exist("mods/twilightdelight-2.0.4.jar")?;
        download_curseforge_file(
            "mods/twilightdelight-2.0.7.jar",
            871735,
            5116432,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Artifacts", processed, total);
        remove_file_if_exist("mods/artifacts-forge-9.2.2.jar")?;
        download_curseforge_file(
            "mods/artifacts-forge-9.3.0.jar",
            312353,
            5152057,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Better Archeology", processed, total);
        remove_file_if_exist("mods/betterarcheology-1.1.5-1.20.1.jar")?;
        download_curseforge_file(
            "mods/betterarcheology-1.1.7-1.20.1.jar",
            835687,
            5158209,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Friends&Foes", processed, total);
        remove_file_if_exist("mods/friendsandfoes-forge-mc1.20.1-2.0.9.jar")?;
        download_curseforge_file(
            "mods/friendsandfoes-forge-mc1.20.1-2.0.10.jar",
            602059,
            5184455,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("JourneyMap", processed, total);
        remove_file_if_exist("mods/journeymap-1.20.1-5.9.18-forge.jar")?;
        download_curseforge_file(
            "mods/journeymap-1.20.1-5.9.18p1-forge.jar",
            32274,
            5157733,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Nether Depths Upgrade", processed, total);
        remove_file_if_exist("mods/netherdepthsupgrade-3.1.3-1.20.jar")?;
        download_curseforge_file(
            "mods/netherdepthsupgrade-3.1.4-1.20.jar",
            670011,
            5150560,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("The Aether: Redux", processed, total);
        remove_file_if_exist("mods/aether-redux-1.3.4-1.20.1-neoforge.jar")?;
        download_curseforge_file(
            "mods/aether-redux-2.0.6-1.20.1-neoforge.jar",
            867237,
            5173184,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("The Outer End", processed, total);
        remove_file_if_exist("mods/TheOuterEnd-1.0.4.jar")?;
        download_curseforge_file(
            "mods/TheOuterEnd-1.0.6.jar",
            430404,
            5158921,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("EMI", processed, total);
        remove_file_if_exist("mods/emi-1.1.1+1.20.1+forge.jar")?;
        download_curseforge_file(
            "mods/emi-1.1.3+1.20.1+forge.jar",
            580555,
            5172928,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Just Enough Items", processed, total);
        remove_file_if_exist("mods/jei-1.20.1-forge-15.3.0.1.jar")?;
        download_curseforge_file(
            "mods/jei-1.20.1-forge-15.3.0.4.jar",
            238222,
            5101366,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Lightman's Currency", processed, total);
        remove_file_if_exist("mods/lightmanscurrency-1.20.1-2.2.0.3c.jar")?;
        download_curseforge_file(
            "mods/lightmanscurrency-1.20.1-2.2.1.0b.jar",
            472521,
            5127058,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Quark", processed, total);
        remove_file_if_exist("mods/Quark-4.0-436.jar")?;
        download_curseforge_file("mods/Quark-4.0-438.jar", 243121, 5151658, is_force_update)
            .await?;
        processed += 1;
        print_progress("Simple Voice Chat", processed, total);
        remove_file_if_exist("mods/voicechat-forge-1.20.1-2.5.2.jar")?;
        download_curseforge_file(
            "mods/voicechat-forge-1.20.1-2.5.8.jar",
            416089,
            5164154,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("CraftTweaker", processed, total);
        remove_file_if_exist("mods/CraftTweaker-forge-1.20.1-14.0.33.jar")?;
        download_curseforge_file(
            "mods/CraftTweaker-forge-1.20.1-14.0.36.jar",
            239197,
            5137190,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("CreateTweaker", processed, total);
        remove_file_if_exist("mods/CreateTweaker-forge-1.20.1-4.0.7.jar")?;
        download_curseforge_file(
            "mods/CreateTweaker-forge-1.20.1-4.0.8.jar",
            437717,
            5116404,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Architectury", processed, total);
        remove_file_if_exist("mods/architectury-9.1.13-forge.jar")?;
        download_curseforge_file(
            "mods/architectury-9.2.14-forge.jar",
            419699,
            5137938,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Balm", processed, total);
        remove_file_if_exist("mods/balm-forge-1.20.1-7.2.1.jar")?;
        download_curseforge_file(
            "mods/balm-forge-1.20.1-7.2.2.jar",
            531761,
            5140912,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Blueprint", processed, total);
        remove_file_if_exist("mods/blueprint-1.20.1-7.0.0.jar")?;
        download_curseforge_file(
            "mods/blueprint-1.20.1-7.0.1.jar",
            382216,
            5147442,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Citadel", processed, total);
        remove_file_if_exist("mods/citadel-2.5.3-1.20.1.jar")?;
        download_curseforge_file(
            "mods/citadel-2.5.4-1.20.1.jar",
            331936,
            5143956,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Curios API", processed, total);
        remove_file_if_exist("mods/curios-forge-5.7.0+1.20.1.jar")?;
        download_curseforge_file(
            "mods/curios-forge-5.7.2+1.20.1.jar",
            309927,
            5175956,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Fusion (Connected Textures)", processed, total);
        remove_file_if_exist("mods/fusion-1.1.0c-forge-mc1.20.1.jar")?;
        download_curseforge_file(
            "mods/fusion-1.1.1-forge-mc1.20.1.jar",
            854949,
            5129294,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Moonlight Lib", processed, total);
        remove_file_if_exist("mods/moonlight-1.20-2.9.12-forge.jar")?;
        download_curseforge_file(
            "mods/moonlight-1.20-2.11.4-forge.jar",
            499980,
            5180872,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("YUNG's API", processed, total);
        remove_file_if_exist("mods/YungsApi-1.20-Forge-4.0.3.jar")?;
        download_curseforge_file(
            "mods/YungsApi-1.20-Forge-4.0.4.jar",
            421850,
            5147001,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Zeta", processed, total);
        remove_file_if_exist("mods/Zeta-1.0-13.jar")?;
        download_curseforge_file("mods/Zeta-1.0-14.jar", 968868, 5151582, is_force_update).await?;
        remove_file_if_exist("mods/craftingtweaks-forge-1.20-18.2.2.jar")?;
        download_curseforge_file(
            "mods/craftingtweaks-forge-1.20.1-18.2.3.jar",
            233071,
            5140224,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Embeddium", processed, total);
        remove_file_if_exist("mods/embeddium-0.3.1+mc1.20.1.jar")?;
        download_curseforge_file(
            "mods/embeddium-0.3.9+mc1.20.1.jar",
            908741,
            5175031,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Oculus", processed, total);
        remove_file_if_exist("mods/oculus-mc1.20.1-1.6.15.jar")?;
        download_curseforge_file(
            "mods/oculus-mc1.20.1-1.6.15a.jar",
            581495,
            5108615,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Tips", processed, total);
        remove_file_if_exist("mods/Tips-Forge-1.20.1-12.0.4.jar")?;
        download_curseforge_file(
            "mods/Tips-Forge-1.20.1-12.0.5.jar",
            306549,
            5134760,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("", processed, total);
        print_sub(Key::UpdaterSceneUpdateModInstall);
        print_progress("Amendments", processed, total);
        download_curseforge_file(
            "mods/amendments-1.20-1.1.10.jar",
            896746,
            5176182,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Copper & Tuff Backport", processed, total);
        download_curseforge_file(
            "mods/copperandtuffbackport-1.2.jar",
            950738,
            5081431,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Create: Copycats+", processed, total);
        download_curseforge_file(
            "mods/Copycats-forge.1.20.1-1.2.4.jar",
            968398,
            5187796,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Create Central Kitchen", processed, total);
        download_curseforge_file(
            "mods/create_central_kitchen-1.20.1-for-create-0.5.1.f-1.3.10.jar",
            820977,
            5132704,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Croptopia", processed, total);
        download_curseforge_file(
            "mods/Croptopia-1.20.1-FORGE-3.0.4.jar",
            415438,
            4997459,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Delightful", processed, total);
        download_curseforge_file(
            "mods/Delightful-1.20.1-3.5.2.jar",
            637529,
            5167936,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("End's Delight", processed, total);
        download_curseforge_file(
            "mods/ends_delight-1.20.1-1.0.1.jar",
            662675,
            4678069,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Miner's Delight", processed, total);
        download_curseforge_file(
            "mods/miners_delight-1.20.1-1.2.3.jar",
            689630,
            5038950,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Ocean's Delight", processed, total);
        download_curseforge_file(
            "mods/oceansdelight-1.0.2-1.20.jar",
            841262,
            4652060,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Undergarden Delight", processed, total);
        download_curseforge_file(
            "mods/undergarden_delight_1.0.0_forge_1.20.1.jar",
            960662,
            5023548,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Backported Wolves", processed, total);
        download_curseforge_file(
            "mods/backported_wolves-1.0.3-1.20.1.jar",
            984037,
            5166541,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Immersive Aircraft", processed, total);
        download_curseforge_file(
            "mods/immersive_aircraft-0.7.5+1.20.1-forge.jar",
            666014,
            5168708,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("The Undergarden", processed, total);
        download_curseforge_file(
            "mods/The_Undergarden-1.20.1-0.8.14.jar",
            379849,
            5182632,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Cosmetic Armor Reworked", processed, total);
        download_curseforge_file(
            "mods/cosmeticarmorreworked-1.20.1-v1a.jar",
            237307,
            4600191,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Curios Quark Oddities Backpack", processed, total);
        download_curseforge_file(
            "mods/CuriosQuarkOBP-1.20.1-1.2.5.jar",
            445208,
            5085092,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Quark Oddities", processed, total);
        download_curseforge_file(
            "mods/QuarkOddities-1.20.1.jar",
            301051,
            5070502,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Spyglass of Curios", processed, total);
        download_curseforge_file(
            "mods/spyglass_of_curios-forge-1.20.1-1.7.2.jar",
            941332,
            5062462,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("EpheroLib", processed, total);
        download_curseforge_file(
            "mods/EpheroLib-1.20.1-FORGE-1.2.0.jar",
            885449,
            4889101,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("NaangisKhan", processed, total);
        download_file("mods/naangiskhan-1.0.0+1.20.1.jar", "https://github.com/kyazuki/NaangisKhan-Modpack-Installer/releases/download/v1.1.0/naangiskhan-1.0.0+1.20.1.jar", is_force_update).await?;
        processed += 1;
        print_sub(Key::UpdaterSceneUpdateResourcePackInstall);
        print_progress("Create Immersive Aircrafts", processed, total);
        download_curseforge_file(
            "resourcepacks/Create Immersive Aircrafts Resource Pack 1.20.1 - 2.0.zip",
            821020,
            5096356,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Nether's Delight crops 3D", processed, total);
        download_curseforge_file(
            "resourcepacks/Nehter's_Delight_crops_3D_1.3.zip",
            965057,
            5122924,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("", processed, total);
        {
            // リソースパックの設定を差し替える
            print_sub(Key::UpdaterSceneUpdateResourcePackReorder);
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
                            eprint_sub(Key::UpdaterSceneUpdateConfigFileError);
                        }
                    }
                }
                Err(e) => {
                    error!("Failed to open {:?}: {:?}", &path, e);
                    eprint_sub(Key::UpdaterSceneUpdateConfigFileNoExist);
                }
            };
        }
        processed += 1;
        print_progress_only(processed, total);
        {
            // タイトル画面で、Aetherのtoggle world/quick loadボタンを除去
            print_fmt_with_sub(
                Key::UpdaterSceneUpdateResourceConfigFile,
                vec!["The Aether"],
                Key::Empty,
            );
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
                            eprint_sub(Key::UpdaterSceneUpdateConfigFileError);
                        }
                    }
                }
                Err(e) => {
                    error!("Failed to open {:?}: {:?}", &path, e);
                    eprint_sub(Key::UpdaterSceneUpdateConfigFileNoExist);
                }
            };
        }
        processed += 1;
        print_progress_only(processed, total);
        {
            // Aether Reduxのタイトル画面変更を抑止
            print_fmt_with_sub(
                Key::UpdaterSceneUpdateResourceConfigFile,
                vec!["The Aether: Redux"],
                Key::Empty,
            );
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
                            eprint_sub(Key::UpdaterSceneUpdateConfigFileError);
                        }
                    }
                }
                Err(e) => {
                    error!("Failed to open {:?}: {:?}", &path, e);
                    eprint_sub(Key::UpdaterSceneUpdateConfigFileNoExist);
                }
            };
        }
        processed += 1;
        print_progress_only(processed, total);
        {
            // Quarkのタイトル画面に表示されるqボタンのポップアップを抑制
            print_fmt_with_sub(
                Key::UpdaterSceneUpdateResourceConfigFile,
                vec!["Quark"],
                Key::Empty,
            );
            let path = ".qmenu_opened.marker";
            match Path::new(path).try_exists() {
                Ok(true) => {}
                Ok(false) => {
                    File::create(path)?;
                    info!("Created {:?}.", &path);
                }
                Err(e) => {
                    error!("Failed to check if {:?} exists: {:?}", &path, e);
                    eprint_sub(Key::UpdaterSceneUpdateConfigFileError);
                }
            }
        }
        processed += 1;
        end_progress(processed, total);
    }
    // v1.1.1アップデート
    if is_old_version(&version, &"1.1.1".try_into()?) {
        let total = 1;
        let mut processed = 0;
        info!("Starting migration for v1.1.1...");
        print_fmt_with_sub(Key::UpdaterSceneUpdateVersion, vec!["v1.1.1"], Key::Empty);
        print_sub(Key::UpdaterSceneUpdateModUpdate);
        print_progress("NaangisKhan", processed, total);
        remove_file_if_exist("mods/naangiskhan-1.0.0+1.20.1.jar")?;
        download_file(
            "mods/naangiskhan-1.0.1+1.20.1.jar",
            "https://github.com/kyazuki/NaangisKhan-Modpack-Installer/releases/download/v1.1.1/naangiskhan-1.0.1+1.20.1.jar",
            is_force_update,
        ).await?;
        processed += 1;
        end_progress(processed, total);
    }
    // v1.1.2アップデート
    if is_old_version(&version, &"1.1.2".try_into()?) {
        let total = 1;
        let mut processed = 0;
        info!("Starting migration for v1.1.2...");
        print_fmt_with_sub(Key::UpdaterSceneUpdateVersion, vec!["v1.1.2"], Key::Empty);
        print_sub(Key::UpdaterSceneUpdateModInstall);
        print_progress("EMIffect", processed, total);
        download_curseforge_file(
            "mods/emiffect-forge-1.1.2+mc1.20.1.jar",
            735528,
            4901311,
            is_force_update,
        )
        .await?;
        processed += 1;
        end_progress(processed, total);
    }
    // v1.1.3アップデート
    if is_old_version(&version, &"1.1.3".try_into()?) {
        let total = 1;
        let mut processed = 0;
        info!("Starting migration for v1.1.3...");
        print_fmt_with_sub(Key::UpdaterSceneUpdateVersion, vec!["v1.1.3"], Key::Empty);
        print_sub(Key::UpdaterSceneUpdateModUpdate);
        print_progress("NaangisKhan", processed, total);
        remove_file_if_exist("mods/naangiskhan-1.0.1+1.20.1.jar")?;
        download_file(
            "mods/naangiskhan-1.1.0+1.20.1.jar",
            "https://github.com/kyazuki/NaangisKhan-Modpack-Installer/releases/download/v1.1.3/naangiskhan-1.1.0+1.20.1.jar",
            is_force_update,
        ).await?;
        processed += 1;
        end_progress(processed, total);
    }
    // v1.1.5アップデート
    if is_old_version(&version, &"1.1.5".try_into()?) {
        let total = 5;
        let mut processed = 0;
        info!("Starting migration for v1.1.5...");
        print_fmt_with_sub(Key::UpdaterSceneUpdateVersion, vec!["v1.1.5"], Key::Empty);
        print_sub(Key::UpdaterSceneUpdateModUpdate);
        print_progress("NaangisKhan", processed, total);
        remove_file_if_exist("mods/naangiskhan-1.1.0+1.20.1.jar")?;
        download_file(
            "mods/naangiskhan-1.2.0+1.20.1.jar",
            "https://github.com/kyazuki/NaangisKhan-Modpack-Installer/releases/download/v1.1.5/naangiskhan-1.2.0+1.20.1.jar",
            is_force_update,
        ).await?;
        processed += 1;
        print_progress("", processed, total);
        print_sub(Key::UpdaterSceneUpdateModInstall);
        print_progress("Server Redirect", processed, total);
        download_curseforge_file(
            "mods/ServerRedirect-ForgeMC20-1.4.5.jar",
            295232,
            4683939,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("SimpleAFK", processed, total);
        download_curseforge_file("mods/simpleafk-1.1.2.jar", 908384, 5218384, is_force_update)
            .await?;
        processed += 1;
        print_progress("What Are They Up To (Watut)", processed, total);
        download_curseforge_file(
            "mods/watut-forge-1.20.1-1.1.1.jar",
            945479,
            5267703,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("CoroUtil", processed, total);
        download_curseforge_file(
            "mods/coroutil-forge-1.20.1-1.3.7.jar",
            237749,
            5096038,
            is_force_update,
        )
        .await?;
        processed += 1;
        end_progress(processed, total);
    }
    // v1.1.6アップデート
    if is_old_version(&version, &"1.1.6".try_into()?) {
        let total = 1;
        let mut processed = 0;
        info!("Starting migration for v1.1.6...");
        print_fmt_with_sub(Key::UpdaterSceneUpdateVersion, vec!["v1.1.6"], Key::Empty);
        print_sub(Key::UpdaterSceneUpdateModUpdate);
        print_progress("NaangisKhan", processed, total);
        remove_file_if_exist("mods/naangiskhan-1.2.0+1.20.1.jar")?;
        download_file(
            "mods/naangiskhan-1.2.1+1.20.1.jar",
            "https://github.com/kyazuki/NaangisKhan-Modpack-Installer/releases/download/v1.1.6/naangiskhan-1.2.1+1.20.1.jar",
            is_force_update,
        ).await?;
        processed += 1;
        end_progress(processed, total);
    }
    // v1.1.8アップデート
    if is_old_version(&version, &"1.1.8".try_into()?) {
        let total = 1;
        let mut processed = 0;
        info!("Starting migration for v1.1.8...");
        print_fmt_with_sub(Key::UpdaterSceneUpdateVersion, vec!["v1.1.8"], Key::Empty);
        print_sub(Key::UpdaterSceneUpdateModUpdate);
        print_progress("TofuCreate", processed, total);
        remove_file_if_exist("mods/tofucreate-1.20.1-0.2.0.jar")?;
        download_curseforge_file(
            "mods/tofucreate-1.20.1-0.2.1.jar",
            924197,
            5253655,
            is_force_update,
        )
        .await?;
        processed += 1;
        end_progress(processed, total);
    }
    // v1.1.9アップデート
    if is_old_version(&version, &"1.1.9".try_into()?) {
        let total = 13;
        let mut processed = 0;
        info!("Starting migration for v1.1.9...");
        print_fmt_with_sub(Key::UpdaterSceneUpdateVersion, vec!["v1.1.9"], Key::Empty);
        print_sub(Key::UpdaterSceneUpdateModUpdate);
        print_progress("Curios API", processed, total);
        remove_file_if_exist("mods/curios-forge-5.7.2+1.20.1.jar")?;
        download_curseforge_file(
            "mods/curios-forge-5.9.1+1.20.1.jar",
            309927,
            5367944,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("NaangisKhan", processed, total);
        remove_file_if_exist("mods/naangiskhan-1.2.1+1.20.1.jar")?;
        download_file(
            "mods/naangiskhan-1.3.0+1.20.1.jar",
            "https://github.com/kyazuki/NaangisKhan-Modpack-Installer/releases/download/v1.1.9/naangiskhan-1.3.0+1.20.1.jar",
            is_force_update,
        ).await?;
        processed += 1;
        print_progress("", processed, total);
        print_sub(Key::UpdaterSceneUpdateModInstall);
        print_progress("Better chunk loading", processed, total);
        download_curseforge_file(
            "mods/betterchunkloading-1.20.1-4.3.jar",
            899487,
            5393775,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Better Fps - Render Distance", processed, total);
        download_curseforge_file(
            "mods/betterfpsdist-1.20.1-4.4.jar",
            551520,
            5333766,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Chromatic Arsenal", processed, total);
        download_curseforge_file(
            "mods/chromaticarsenal-1.20.1-1.20.1.jar",
            656420,
            5369583,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Chunk Loaders", processed, total);
        download_curseforge_file(
            "mods/chunkloaders-1.2.8a-forge-mc1.20.1.jar",
            402924,
            4850872,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Client Crafting", processed, total);
        download_curseforge_file(
            "mods/clientcrafting-1.20.1-1.8.jar",
            888790,
            5097009,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Connectivity", processed, total);
        download_curseforge_file(
            "mods/connectivity-1.20.1-5.5.jar",
            470193,
            5181534,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Cupboard", processed, total);
        download_curseforge_file(
            "mods/cupboard-1.20.1-2.6.jar",
            326652,
            5170315,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Farsight", processed, total);
        download_curseforge_file(
            "mods/farsight-1.20.1-3.6.jar",
            495693,
            4870168,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("FerriteCore", processed, total);
        download_curseforge_file(
            "mods/ferritecore-6.0.1-forge.jar",
            429235,
            4810975,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Galosphere", processed, total);
        download_curseforge_file(
            "mods/Galosphere-1.20.1-1.4.1-Forge.jar",
            631098,
            4983871,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("ModernFix", processed, total);
        download_curseforge_file(
            "mods/modernfix-forge-5.18.0+mc1.20.1.jar",
            790626,
            5399361,
            is_force_update,
        )
        .await?;
        processed += 1;
        end_progress(processed, total);
    }
    // v1.1.11アップデート
    if is_old_version(&version, &"1.1.11".try_into()?) {
        let total = 53;
        let mut processed = 0;
        info!("Starting migration for v1.1.11...");
        print_fmt_with_sub(Key::UpdaterSceneUpdateVersion, vec!["v1.1.11"], Key::Empty);
        // Oculus Flywheel Compat - One Off Fixを削除
        print_sub(Key::UpdaterSceneUpdateModRemove);
        print_progress("Oculus Flywheel Compat - One Off Fix", processed, total);
        remove_file_if_exist("mods/oculus-flywheel-compat-fix-1.20.1-1.jar")?;
        processed += 1;
        print_progress("", processed, total);
        print_sub(Key::UpdaterSceneUpdateModUpdate);
        print_progress("Amendments", processed, total);
        remove_file_if_exist("mods/amendments-1.20-1.1.10.jar")?;
        download_curseforge_file(
            "mods/amendments-1.20-1.2.8.jar",
            896746,
            5467925,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Create: Copycats+", processed, total);
        remove_file_if_exist("mods/Copycats-forge.1.20.1-1.2.4.jar")?;
        download_curseforge_file(
            "mods/copycats-1.3.8+mc.1.20.1-forge.jar",
            968398,
            5481590,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Create Deco", processed, total);
        remove_file_if_exist("mods/createdeco-2.0.1-1.20.1-forge.jar")?;
        download_curseforge_file(
            "mods/createdeco-2.0.2-1.20.1-forge.jar",
            509285,
            5293982,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Rechiseled", processed, total);
        remove_file_if_exist("mods/rechiseled-1.1.5c-forge-mc1.20.jar")?;
        download_curseforge_file(
            "mods/rechiseled-1.1.6-forge-mc1.20.jar",
            558998,
            5286306,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Supplementaries", processed, total);
        remove_file_if_exist("mods/supplementaries-1.20-2.8.6.jar")?;
        download_curseforge_file(
            "mods/supplementaries-1.20-2.8.17.jar",
            412082,
            5458843,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Botania", processed, total);
        remove_file_if_exist("mods/Botania-1.20.1-443-FORGE.jar")?;
        download_curseforge_file(
            "mods/Botania-1.20.1-444-FORGE.jar",
            225643,
            5346280,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Create Enchantment Industry", processed, total);
        remove_file_if_exist(
            "mods/create_enchantment_industry-1.20.1-for-create-0.5.1.f-1.2.7.h.jar",
        )?;
        download_curseforge_file(
            "mods/create_enchantment_industry-1.20.1-for-create-0.5.1.f-1.2.9.d.jar",
            688768,
            5331908,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Create: Steam 'n' Rails", processed, total);
        remove_file_if_exist("mods/Steam_Rails-1.5.3+forge-mc1.20.1.jar")?;
        download_curseforge_file(
            "mods/Steam_Rails-1.6.4+forge-mc1.20.1.jar",
            688231,
            5331300,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Create Central Kitchen", processed, total);
        remove_file_if_exist("mods/create_central_kitchen-1.20.1-for-create-0.5.1.f-1.3.10.jar")?;
        download_curseforge_file(
            "mods/create_central_kitchen-1.20.1-for-create-0.5.1.f-1.3.12.jar",
            820977,
            5232178,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Delightful", processed, total);
        remove_file_if_exist("mods/Delightful-1.20.1-3.5.2.jar")?;
        download_curseforge_file(
            "mods/Delightful-1.20.1-3.5.6.jar",
            637529,
            5460247,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("End's Delight", processed, total);
        remove_file_if_exist("mods/ends_delight-1.20.1-1.0.1.jar")?;
        download_curseforge_file(
            "mods/ends_delight-1.20.1-2.3.jar",
            662675,
            5483124,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("TofuCraftReload", processed, total);
        remove_file_if_exist("mods/TofuCraftReload-1.20.1-5.10.4.1.jar")?;
        download_curseforge_file(
            "mods/TofuCraftReload-1.20.1-5.12.2.0.jar",
            317469,
            5405518,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Twilight's Flavors & Delight", processed, total);
        remove_file_if_exist("mods/twilightdelight-2.0.7.jar")?;
        download_curseforge_file(
            "mods/twilightdelight-2.0.11.jar",
            871735,
            5271010,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Artifacts", processed, total);
        remove_file_if_exist("mods/artifacts-forge-9.3.0.jar")?;
        download_curseforge_file(
            "mods/artifacts-forge-9.5.11.jar",
            312353,
            5414790,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Better Archeology", processed, total);
        remove_file_if_exist("mods/betterarcheology-1.1.7-1.20.1.jar")?;
        download_curseforge_file(
            "mods/betterarcheology-1.1.9-1.20.1.jar",
            835687,
            5343082,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Deep Aether", processed, total);
        remove_file_if_exist("mods/deep_aether-1.20.1-1.0.2.jar")?;
        download_curseforge_file(
            "mods/deep_aether-1.20.1-1.0.4.jar",
            852465,
            5441091,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Immersive Aircraft", processed, total);
        remove_file_if_exist("mods/immersive_aircraft-0.7.5+1.20.1-forge.jar")?;
        download_curseforge_file(
            "mods/immersive_aircraft-1.0.1+1.20.1-forge.jar",
            666014,
            5351805,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("JourneyMap", processed, total);
        remove_file_if_exist("mods/journeymap-1.20.1-5.9.18p1-forge.jar")?;
        download_curseforge_file(
            "mods/journeymap-1.20.1-5.10.0-forge.jar",
            32274,
            5458344,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Nether Depths Upgrade", processed, total);
        remove_file_if_exist("mods/netherdepthsupgrade-3.1.4-1.20.jar")?;
        download_curseforge_file(
            "mods/netherdepthsupgrade-3.1.5-1.20.jar",
            670011,
            5340329,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("The Aether", processed, total);
        remove_file_if_exist("mods/aether-1.20.1-1.2.0-neoforge.jar")?;
        download_curseforge_file(
            "mods/aether-1.20.1-1.4.2-neoforge.jar",
            255308,
            5302178,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("The Aether: Redux", processed, total);
        remove_file_if_exist("mods/aether-redux-2.0.6-1.20.1-neoforge.jar")?;
        download_curseforge_file(
            "mods/aether-redux-2.0.16c-1.20.1-neoforge.jar",
            867237,
            5415985,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("The Outer End", processed, total);
        remove_file_if_exist("mods/TheOuterEnd-1.0.6.jar")?;
        download_curseforge_file(
            "mods/TheOuterEnd-1.0.9.jar",
            430404,
            5183463,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("The Twilight Forest", processed, total);
        remove_file_if_exist("mods/twilightforest-1.20.1-4.3.2145-universal.jar")?;
        download_curseforge_file(
            "mods/twilightforest-1.20.1-4.3.2508-universal.jar",
            227639,
            5468648,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Ars Nouveau", processed, total);
        remove_file_if_exist("mods/ars_nouveau-1.20.1-4.9.0-all.jar")?;
        download_curseforge_file(
            "mods/ars_nouveau-1.20.1-4.12.1-all.jar",
            401955,
            5436131,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("EMI", processed, total);
        remove_file_if_exist("mods/emi-1.1.3+1.20.1+forge.jar")?;
        download_curseforge_file(
            "mods/emi-1.1.10+1.20.1+forge.jar",
            580555,
            5497473,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Just Enough Archaeology", processed, total);
        remove_file_if_exist("mods/jearchaeology-1.20.1-1.0.3.jar")?;
        download_curseforge_file(
            "mods/jearchaeology-1.20.1-1.0.4.jar",
            890755,
            5324518,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Just Enough Items", processed, total);
        remove_file_if_exist("mods/jei-1.20.1-forge-15.3.0.4.jar")?;
        download_curseforge_file(
            "mods/jei-1.20.1-forge-15.3.0.8.jar",
            238222,
            5440261,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Lightman's Currency", processed, total);
        remove_file_if_exist("mods/lightmanscurrency-1.20.1-2.2.1.0b.jar")?;
        download_curseforge_file(
            "mods/lightmanscurrency-1.20.1-2.2.2.2.jar",
            472521,
            5491195,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Polymorph", processed, total);
        remove_file_if_exist("mods/polymorph-forge-0.49.2+1.20.1.jar")?;
        download_curseforge_file(
            "mods/polymorph-forge-0.49.5+1.20.1.jar",
            388800,
            5372401,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Quark", processed, total);
        remove_file_if_exist("mods/Quark-4.0-438.jar")?;
        download_curseforge_file("mods/Quark-4.0-458.jar", 243121, 5418252, is_force_update)
            .await?;
        processed += 1;
        print_progress("Simple Voice Chat", processed, total);
        remove_file_if_exist("mods/voicechat-forge-1.20.1-2.5.8.jar")?;
        download_curseforge_file(
            "mods/voicechat-forge-1.20.1-2.5.17.jar",
            416089,
            5438656,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("ModernFix", processed, total);
        remove_file_if_exist("mods/modernfix-forge-5.18.0+mc1.20.1.jar")?;
        download_curseforge_file(
            "mods/modernfix-forge-5.18.1+mc1.20.1.jar",
            790626,
            5425647,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("CraftTweaker", processed, total);
        remove_file_if_exist("mods/CraftTweaker-forge-1.20.1-14.0.36.jar")?;
        download_curseforge_file(
            "mods/CraftTweaker-forge-1.20.1-14.0.40.jar",
            239197,
            5375591,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("CreateTweaker", processed, total);
        remove_file_if_exist("mods/CreateTweaker-forge-1.20.1-4.0.8.jar")?;
        download_curseforge_file(
            "mods/CreateTweaker-forge-1.20.1-4.0.9.jar",
            437717,
            5193777,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Balm", processed, total);
        remove_file_if_exist("mods/balm-forge-1.20.1-7.2.2.jar")?;
        download_curseforge_file(
            "mods/balm-forge-1.20.1-7.3.6-all.jar",
            531761,
            5467600,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Blueprint", processed, total);
        remove_file_if_exist("mods/blueprint-1.20.1-7.0.1.jar")?;
        download_curseforge_file(
            "mods/blueprint-1.20.1-7.1.0.jar",
            382216,
            5292242,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Bookshelf", processed, total);
        remove_file_if_exist("mods/Bookshelf-Forge-1.20.1-20.1.9.jar")?;
        download_curseforge_file(
            "mods/Bookshelf-Forge-1.20.1-20.2.13.jar",
            228525,
            5423987,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Cupboard", processed, total);
        remove_file_if_exist("mods/cupboard-1.20.1-2.6.jar")?;
        download_curseforge_file(
            "mods/cupboard-1.20.1-2.7.jar",
            326652,
            5470032,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("GeckoLib", processed, total);
        remove_file_if_exist("mods/geckolib-forge-1.20.1-4.4.2.jar")?;
        download_curseforge_file(
            "mods/geckolib-forge-1.20.1-4.4.7.jar",
            388172,
            5460309,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Moonlight Lib", processed, total);
        remove_file_if_exist("mods/moonlight-1.20-2.11.4-forge.jar")?;
        download_curseforge_file(
            "mods/moonlight-1.20-2.12.6-forge.jar",
            499980,
            5478857,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Placebo", processed, total);
        remove_file_if_exist("mods/Placebo-1.20.1-8.6.1.jar")?;
        download_curseforge_file(
            "mods/Placebo-1.20.1-8.6.2.jar",
            283644,
            5414631,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Resourceful Lib", processed, total);
        remove_file_if_exist("mods/resourcefullib-forge-1.20.1-2.1.23.jar")?;
        download_curseforge_file(
            "mods/resourcefullib-forge-1.20.1-2.1.25.jar",
            570073,
            5361260,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Searchables", processed, total);
        remove_file_if_exist("mods/Searchables-forge-1.20.1-1.0.2.jar")?;
        download_curseforge_file(
            "mods/Searchables-forge-1.20.1-1.0.3.jar",
            858542,
            5284015,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("TerraBlender", processed, total);
        remove_file_if_exist("mods/TerraBlender-forge-1.20.1-3.0.1.4.jar")?;
        download_curseforge_file(
            "mods/TerraBlender-forge-1.20.1-3.0.1.7.jar",
            563928,
            5378180,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("YUNG's API", processed, total);
        remove_file_if_exist("mods/YungsApi-1.20-Forge-4.0.4.jar")?;
        download_curseforge_file(
            "mods/YungsApi-1.20-Forge-4.0.5.jar",
            421850,
            5331703,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Zeta", processed, total);
        remove_file_if_exist("mods/Zeta-1.0-14.jar")?;
        download_curseforge_file("mods/Zeta-1.0-19.jar", 968868, 5418213, is_force_update).await?;
        processed += 1;
        print_progress("Better Advancements", processed, total);
        remove_file_if_exist("mods/BetterAdvancements-1.20.1-0.3.2.162.jar")?;
        download_curseforge_file(
            "mods/BetterAdvancements-Forge-1.20.1-0.4.2.10.jar",
            272515,
            5454907,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Crafting Tweaks", processed, total);
        remove_file_if_exist("mods/craftingtweaks-forge-1.20.1-18.2.3.jar")?;
        download_curseforge_file(
            "mods/craftingtweaks-forge-1.20.1-18.2.4.jar",
            233071,
            5396016,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Embeddium", processed, total);
        remove_file_if_exist("mods/embeddium-0.3.9+mc1.20.1.jar")?;
        download_curseforge_file(
            "mods/embeddium-0.3.23+mc1.20.1.jar",
            908741,
            5496987,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Mouse Tweaks", processed, total);
        remove_file_if_exist("mods/MouseTweaks-forge-mc1.20-2.25.jar")?;
        download_curseforge_file(
            "mods/MouseTweaks-forge-mc1.20.1-2.25.1.jar",
            60089,
            5338457,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Not Enough Animations", processed, total);
        remove_file_if_exist("mods/notenoughanimations-forge-1.7.1-mc1.20.1.jar")?;
        download_curseforge_file(
            "mods/notenoughanimations-forge-1.7.4-mc1.20.1.jar",
            433760,
            5429265,
            is_force_update,
        )
        .await?;
        processed += 1;
        print_progress("Oculus", processed, total);
        remove_file_if_exist("mods/oculus-mc1.20.1-1.6.15a.jar")?;
        download_curseforge_file(
            "mods/oculus-mc1.20.1-1.7.0.jar",
            581495,
            5299671,
            is_force_update,
        )
        .await?;
        processed += 1;
        end_progress(processed, total);
    }
    // v1.2.0アップデート
    if is_old_version(&version, &"1.2.0".try_into()?) {
        let total = 1;
        let mut processed = 0;
        info!("Starting migration for v1.2.0...");
        print_fmt_with_sub(Key::UpdaterSceneUpdateVersion, vec!["v1.2.0"], Key::Empty);
        print_sub(Key::UpdaterSceneUpdateModUpdate);
        print_progress("Friends&Foes", processed, total);
        remove_file_if_exist("mods/friendsandfoes-forge-mc1.20.1-2.0.10.jar")?;
        download_curseforge_file(
            "mods/friendsandfoes-forge-mc1.20.1-2.0.11.jar",
            602059,
            5499042,
            is_force_update,
        )
        .await?;
        processed += 1;
        end_progress(processed, total);
    }

    Ok(())
}
