#!/bin/bash
# Javaがなければインストール
java --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
    if [ "$(uname)" == 'Darwin']; then  # macOS
        echo -e Javaのインストールが必要です。下記リンクからインストールした後に再実行してください。\\nhttps://www.oracle.com/jp/java/technologies/downloads/#jdk17-mac 1>&2
        exit 1
    else    # Linux
        sudo apt update > /dev/null 2>&1
        sudo apt install -y openjdk-17-jdk > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo Javaのインストールに失敗しました。 1>&2
            exit 1
        fi
    fi
fi
# 設定ファイル・リソースをダウンロードして展開
echo リソースをダウンロード中...
curl -OLsSf https://github.com/kyazuki/NaangisKhan-Modpack-Installer/releases/download/v1.2.0/client.zip 2>/dev/null
if [ $? -ne 0 ]; then
    echo リソースのダウンロードに失敗しました。 1>&2
    exit 1
fi
jar --version > /dev/null 2>&1
if [ $? -eq 0 ]; then   # jarコマンドが使える場合
    jar xf client.zip > /dev/null 2>&1
else # jarコマンドが使えない場合
    unzip client.zip > /dev/null 2>&1
fi
if [ $? -ne 0 ]; then
    echo リソースの展開に失敗しました。 1>&2
    exit 1
fi
rm client.zip
# インストーラーをダウンロードして実行
echo インストーラーをダウンロード中...
curl -o minecraft-modpack-installer.jar -LsSf https://github.com/kyazuki/Minecraft-Modpack-Installer/releases/download/v2.0.1/minecraft-modpack-installer-2.0.1.jar 2>/dev/null
if [ $? -ne 0 ]; then
    echo インストーラーのダウンロードに失敗しました。 1>&2
fi
echo インストール中...
java -jar minecraft-modpack-installer.jar