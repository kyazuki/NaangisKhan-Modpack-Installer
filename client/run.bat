@echo off
setlocal
REM "文字コードをUTF-8に設定"
chcp 65001 > nul
REM "インストール済みかチェック"
if exist mods\ (
    REM "アップデート処理に切り替え"
    bitsadmin /transfer installer /priority FOREGROUND https://github.com/kyazuki/NaangisKhan-Modpack-Installer/releases/latest/download/update.bat "%CD%\update.bat" > nul
    call update.bat
    if errorlevel 1 (
        echo アップデートに失敗しました。 1>&2
        pause
        exit 1
    ) else (
        exit 0
    )
)
REM "Javaがなければインストール"
java --version > nul 2>&1
if not %errorlevel% == 0 (
    winget list --id Microsoft.OpenJDK.17 -s winget > nul 2>&1
    if errorlevel 1 (
        REM "winget経由で未インストールのとき"
        echo Javaをインストール中...
        winget install --id Microsoft.OpenJDK.17 --accept-package-agreements --accept-source-agreements > nul 2>&1
        if errorlevel 1 (
            echo Javaのインストールに失敗しました。 1>&2
            pause
            exit 1
        )
        echo Javaのインストールが完了しました。再度実行してください。
        pause
        exit 0
    ) else (
        REM "winget経由でインストール済みのとき"
        echo "インストール済みのJavaを発見しました"
        for /f "tokens=* USEBACKQ" %%F in (`where /r %LocalAppData%\Programs\Microsoft java.exe`) do (
            set "JAVA=%%F"
        )
    )
)
REM "設定ファイル・リソースをダウンロードして展開"
echo リソースをダウンロード中...
bitsadmin /transfer resources /priority FOREGROUND https://github.com/kyazuki/NaangisKhan-Modpack-Installer/releases/download/v1.0.16/client.zip "%CD%\client.zip" > nul
if errorlevel 1 (
    echo リソースのダウンロードに失敗しました。 1>&2
    pause
    exit 1
)
jar xf client.zip > nul 2>&1
if errorlevel 1 (
    tar -xf client.zip > nul 2>&1
    if errorlevel 1 (
        call powershell -command "Expand-Archive -Force -Path client.zip -DestinationPath .\ | Out-Null" > nul 2>&1
        if errorlevel 1 (
            echo リソースの展開に失敗しました。 1>&2
            pause
            exit 1
        )
    )
)
del client.zip
REM "インストーラーをダウンロードして実行"
echo インストーラーをダウンロード中...
bitsadmin /transfer installer /priority FOREGROUND https://github.com/kyazuki/Minecraft-Modpack-Installer/releases/download/v2.0.0/minecraft-modpack-installer-2.0.0.jar "%CD%\minecraft-modpack-installer.jar" > nul
if errorlevel 1 (
    echo インストーラーのダウンロードに失敗しました。 1>&2
    pause
    exit 1
)
echo インストール中...
if defined JAVA (
    %JAVA% -jar minecraft-modpack-installer.jar
) else (
    java -jar minecraft-modpack-installer.jar
)
endlocal