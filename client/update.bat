@echo off
setlocal enabledelayedexpansion
REM "文字コードをUTF-8に設定"
chcp 65001 > nul
echo アップデートを開始します...
REM "旧リソースパックが残っていれば削除"
if exist resourcepacks\NaangisKhan (
    rmdir /q /s resourcepacks\Naangiskhan > nul 2>&1
    set OLD_RESOURCES=1
)
if exist resourcepacks\Naan.zip (
    del /q resourcepacks\Naan.zip > nul 2>&1
    set OLD_RESOURCES=1
)
REM "旧仕様であればリソースパックの設定を差し替える"
if defined OLD_RESOURCES (
    if not exist options.txt (
        echo 設定ファイルが存在しません。 1>&2
        pause
        exit 1
    )
    REM "'resourcePacks'の行を抽出"
    for /f "tokens=* USEBACKQ" %%F in (`findstr /b resourcePacks options.txt`) do (
        set "RESOURCE_PACKS=%%F"
    )
    REM "'resourcePacks'の配列値を抽出"
    set RESOURCE_PACKS=!RESOURCE_PACKS:~15,-1!
    set AFTER_RESOURCE_PACKS=
    set left=!RESOURCE_PACKS!
    REM "'Naangiskhan'と'Naan.zip'以外を順に取り出して列挙"
    :loop
    for /f "tokens=1* delims=," %%a in ("%left%") do (
        if not %%a == "file/Naangiskhan" if not %%a == "file/Naan.zip" (
            set AFTER_RESOURCE_PACKS=%AFTER_RESOURCE_PACKS%,%%a
        )
        set left=%%b
    )
    if defined left goto :loop
    REM "'NaangisKhan.zip'を末尾(優先度最高)に追加する"
    set AFTER_RESOURCE_PACKS=%AFTER_RESOURCE_PACKS:~1%,"file/NaangisKhan.zip"
    del /q options.txt.tmp > nul 2>&1
    for /f "delims=" %%L in (options.txt) do (
        echo %%L | find "resourcePacks" > nul 2>&1
        if errorlevel 1 (
            (echo %%L) >> options.txt.tmp
        ) else (
            (echo resourcePacks:[%AFTER_RESOURCE_PACKS%]) >> options.txt.tmp
        )
    )
    move /y options.txt.tmp options.txt > nul 2>&1
)
REM "最新のリソースパックをダウンロード"
echo リソースパックを更新中...
bitsadmin /transfer installer /priority FOREGROUND https://github.com/kyazuki/NaangisKhan-Modpack-Installer/releases/download/v%LATEST_VERSION%/NaangisKhan.zip "%CD%\resourcepacks\NaangisKhan.zip" > nul
if errorlevel 1 (
    echo リソースパックのダウンロードに失敗しました。 1>&2
    pause
    exit 1
)
REM "マイグレーション処理"
echo アップデート中...
REM "v1.0.15アップデート"
call :is_old_version 1.0.15
if not errorlevel 1 (
    call :download_file "%CD%\mods\polymorph-forge-0.49.2+1.20.1.jar" 388800 4928442
)
REM "v1.1.0アップデート"
call :is_old_version 1.1.0
if not errorlevel 1 (
    REM "既存Modのアップデート"
    del /q "%CD%\mods\supplementaries-1.20-2.7.35.jar" > nul 2>&1
    call :download_file "%CD%\mods\supplementaries-1.20-2.8.6.jar" 412082 5154529
    del /q "%CD%\mods\handcrafted-forge-1.20.1-3.0.5.jar" > nul 2>&1
    call :download_file "%CD%\mods\handcrafted-forge-1.20.1-3.0.6.jar" 538214 5118729
    del /q "%CD%\mods\TofuCraftReload-1.20.1-5.9.0.1.jar" > nul 2>&1
    call :download_file "%CD%\mods\TofuCraftReload-1.20.1-5.10.4.1.jar" 317469 5181742
    del /q "%CD%\mods\tofudelight-1.20.1-2.4.1.jar" > nul 2>&1
    call :download_file "%CD%\mods\tofudelight-1.20.1-2.5.0.jar" 835619 5112167
    del /q "%CD%\mods\twilightdelight-2.0.4.jar" > nul 2>&1
    call :download_file "%CD%\mods\twilightdelight-2.0.7.jar" 871735 5116432
    del /q "%CD%\mods\tofucreate-1.20.1-0.1.0.jar" > nul 2>&1
    call :download_file "%CD%\mods\tofucreate-1.20.1-0.2.0.jar" 924197 5109349
    del /q "%CD%\mods\journeymap-1.20.1-5.9.18-forge.jar" > nul 2>&1
    call :download_file "%CD%\mods\journeymap-1.20.1-5.9.18p1-forge.jar" 32274 5157733
    del /q "%CD%\mods\artifacts-forge-9.2.2.jar" > nul 2>&1
    call :download_file "%CD%\mods\artifacts-forge-9.3.0.jar" 312353 5152057
    del /q "%CD%\mods\friendsandfoes-forge-mc1.20.1-2.0.9.jar" > nul 2>&1
    call :download_file "%CD%\mods\friendsandfoes-forge-mc1.20.1-2.0.10.jar" 602059 5184455
    del /q "%CD%\mods\netherdepthsupgrade-3.1.3-1.20.jar" > nul 2>&1
    call :download_file "%CD%\mods\netherdepthsupgrade-3.1.4-1.20.jar" 670011 5150560
    del /q "%CD%\mods\betterarcheology-1.1.5-1.20.1.jar" > nul 2>&1
    call :download_file "%CD%\mods\betterarcheology-1.1.7-1.20.1.jar" 835687 5158209
    del /q "%CD%\mods\TheOuterEnd-1.0.4.jar" > nul 2>&1
    call :download_file "%CD%\mods\TheOuterEnd-1.0.6.jar" 430404 5158921
    del /q "%CD%\mods\aether-redux-1.3.4-1.20.1-neoforge.jar" > nul 2>&1
    call :download_file "%CD%\mods\aether-redux-2.0.6-1.20.1-neoforge.jar" 867237 5173184
    del /q "%CD%\mods\ars_creo-1.20.1-4.0.1.jar" > nul 2>&1
    call :download_file "%CD%\mods\ars_creo-1.20.1-4.1.0.jar" 575698 5171755
    del /q "%CD%\mods\voicechat-forge-1.20.1-2.5.2.jar" > nul 2>&1
    call :download_file "%CD%\mods\voicechat-forge-1.20.1-2.5.8.jar" 416089 5164154
    del /q "%CD%\mods\lightmanscurrency-1.20.1-2.2.0.3c.jar" > nul 2>&1
    call :download_file "%CD%\mods\lightmanscurrency-1.20.1-2.2.1.0b.jar" 472521 5127058
    del /q "%CD%\mods\jei-1.20.1-forge-15.3.0.1.jar" > nul 2>&1
    call :download_file "%CD%\mods\jei-1.20.1-forge-15.3.0.4.jar" 238222 5101366
    del /q "%CD%\mods\emi-1.1.1+1.20.1+forge.jar" > nul 2>&1
    call :download_file "%CD%\mods\emi-1.1.3+1.20.1+forge.jar" 580555 5172928
    del /q "%CD%\mods\Quark-4.0-436.jar" > nul 2>&1
    call :download_file "%CD%\mods\Quark-4.0-438.jar" 243121 5151658
    del /q "%CD%\mods\oculus-mc1.20.1-1.6.15.jar" > nul 2>&1
    call :download_file "%CD%\mods\oculus-mc1.20.1-1.6.15a.jar" 581495 5108615
    del /q "%CD%\mods\embeddium-0.3.1+mc1.20.1.jar" > nul 2>&1
    call :download_file "%CD%\mods\embeddium-0.3.9+mc1.20.1.jar" 908741 5175031
    del /q "%CD%\mods\Tips-Forge-1.20.1-12.0.4.jar" > nul 2>&1
    call :download_file "%CD%\mods\Tips-Forge-1.20.1-12.0.5.jar" 306549 5134760
    del /q "%CD%\mods\craftingtweaks-forge-1.20-18.2.2.jar" > nul 2>&1
    call :download_file "%CD%\mods\craftingtweaks-forge-1.20.1-18.2.3.jar" 233071 5140224
    del /q "%CD%\mods\CraftTweaker-forge-1.20.1-14.0.33.jar" > nul 2>&1
    call :download_file "%CD%\mods\CraftTweaker-forge-1.20.1-14.0.36.jar" 239197 5137190
    del /q "%CD%\mods\CreateTweaker-forge-1.20.1-4.0.7.jar" > nul 2>&1
    call :download_file "%CD%\mods\CreateTweaker-forge-1.20.1-4.0.8.jar" 437717 5116404
    del /q "%CD%\mods\YungsApi-1.20-Forge-4.0.3.jar" > nul 2>&1
    call :download_file "%CD%\mods\YungsApi-1.20-Forge-4.0.4.jar" 421850 5147001
    del /q "%CD%\mods\citadel-2.5.3-1.20.1.jar" > nul 2>&1
    call :download_file "%CD%\mods\citadel-2.5.4-1.20.1.jar" 331936 5143956
    del /q "%CD%\mods\moonlight-1.20-2.9.12-forge.jar" > nul 2>&1
    call :download_file "%CD%\mods\moonlight-1.20-2.11.4-forge.jar" 499980 5180872
    del /q "%CD%\mods\architectury-9.1.13-forge.jar" > nul 2>&1
    call :download_file "%CD%\mods\architectury-9.2.14-forge.jar" 419699 5137938
    del /q "%CD%\mods\Zeta-1.0-13.jar" > nul 2>&1
    call :download_file "%CD%\mods\Zeta-1.0-14.jar" 968868 5151582
    del /q "%CD%\mods\balm-forge-1.20.1-7.2.1.jar" > nul 2>&1
    call :download_file "%CD%\mods\balm-forge-1.20.1-7.2.2.jar" 531761 5140912
    del /q "%CD%\mods\fusion-1.1.0c-forge-mc1.20.1.jar" > nul 2>&1
    call :download_file "%CD%\mods\fusion-1.1.1-forge-mc1.20.1.jar" 854949 5129294
    del /q "%CD%\mods\blueprint-1.20.1-7.0.0.jar" > nul 2>&1
    call :download_file "%CD%\mods\blueprint-1.20.1-7.0.1.jar" 382216 5147442
    del /q "%CD%\mods\curios-forge-5.7.0+1.20.1.jar" > nul 2>&1
    call :download_file "%CD%\mods\curios-forge-5.7.2+1.20.1.jar" 309927 5175956
    REM "リソースパックの設定を差し替える"
    if not exist options.txt (
        echo 設定ファイルが存在しません。 1>&2
        pause
        exit 1
    )
    REM "'resourcePacks'の行を抽出"
    for /f "tokens=* USEBACKQ" %%F in (`findstr /b resourcePacks options.txt`) do (
        set "RESOURCE_PACKS=%%F"
    )
    REM "'resourcePacks'の配列値を抽出"
    set RESOURCE_PACKS=!RESOURCE_PACKS:~15,-1!
    set AFTER_RESOURCE_PACKS=
    set left=!RESOURCE_PACKS!
    REM "'NaangisKhan.zip'と本アプデで追加されるパック以外を順に取り出して列挙"
    :v1.1.0loop
    for /f "tokens=1* delims=," %%a in ("%left%") do (
        if not %%a == "builtin/resource/overrides_pack" if not %%a == "builtin/resource/redux_tips" if not %%a == "file/NaangisKhan.zip" (
            set AFTER_RESOURCE_PACKS=%AFTER_RESOURCE_PACKS%,%%a
        )
        set left=%%b
    )
    if defined left goto :v1.1.0loop
    REM "先頭の','を削除"
    set AFTER_RESOURCE_PACKS=%AFTER_RESOURCE_PACKS:~1%
    REM "'NaangisKhan.zip'を末尾(優先度最高)に追加する"
    set AFTER_RESOURCE_PACKS=%AFTER_RESOURCE_PACKS%,"builtin/resource/overrides_pack"
    set AFTER_RESOURCE_PACKS=%AFTER_RESOURCE_PACKS%,"builtin/resource/redux_tips"
    set AFTER_RESOURCE_PACKS=%AFTER_RESOURCE_PACKS%,"file/NaangisKhan.zip"
    del /q options.txt.tmp > nul 2>&1
    for /f "delims=" %%L in (options.txt) do (
        echo %%L | find "resourcePacks" > nul 2>&1
        if errorlevel 1 (
            (echo %%L) >> options.txt.tmp
        ) else (
            (echo resourcePacks:[%AFTER_RESOURCE_PACKS%]) >> options.txt.tmp
        )
    )
    move /y options.txt.tmp options.txt > nul 2>&1
)
exit /b 0

REM "現行バージョンが指定されたバージョンより古いかを判定するサブルーチン"
:is_old_version
REM "直接update.batが実行された場合(INSTALLED_VERSIONが未定義)は強制アップデートとする"
if not defined INSTALLED_VERSION (
    exit /b 0
)
set CHECK_VERSION=%1
for /f "tokens=1* delims=." %%a in ("%1") do (
    set check_major=%%a
    set check_minor=%%b
    set check_patch=%%c
)
for /f "tokens=1* delims=." %%a in ("%INSTALLED_VERSION%") do (
    if %%a lss %check_major% (
        exit /b 0
    ) else if %%b lss %check_minor% (
        exit /b 0
    ) else if %%c lss %check_patch% (
        exit /b 0
    )
)
exit /b 1

REM "指定されたパスへ、指定されたProjectID・FileIDでCurseForgeからファイルをダウンロードするサブルーチン"
REM "ダウンロードエラーが発生した場合はプロセスを終了させる"
:download_file
if not exist %1 (
    bitsadmin /transfer installer /priority FOREGROUND https://www.curseforge.com/api/v1/mods/%2/files/%3/download %1 > nul
    if not exist %1 (
        echo ファイルのダウンロードに失敗しました。 1>&2
        echo 詳細: %1
        exit 1
    )
)
exit /b 0

endlocal