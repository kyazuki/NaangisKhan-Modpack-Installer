@echo off
REM "Java���Ȃ���΃C���X�g�[��"
java --version > nul 2>&1
if errorlevel 1 (
    echo Java���C���X�g�[����...
    winget install --id Microsoft.OpenJDK.17 > nul 2>&1
    if errorlevel 1 (
        echo Java�̃C���X�g�[���Ɏ��s���܂����B 1>&2
        pause
        exit 1
    )
    echo Java�̃C���X�g�[�����������܂����B�ēx���s���Ă��������B
    pause
    exit 0
)
REM "�ݒ�t�@�C���E���\�[�X���_�E�����[�h���ēW�J"
echo ���\�[�X���_�E�����[�h��...
bitsadmin /transfer resources /priority FOREGROUND https://github.com/kyazuki/NaangisKhan-Modpack-Installer/releases/download/v1.0.5/client.zip "%CD%\client.zip" > nul
if errorlevel 1 (
    echo ���\�[�X�̃_�E�����[�h�Ɏ��s���܂����B 1>&2
    pause
    exit 1
)
jar xf client.zip > nul 2>&1
if errorlevel 1 (
    tar -xf client.zip > nul 2>&1
    if errorlevel 1 (
        call powershell -command "Expand-Archive -Force -Path client.zip -DestinationPath .\ | Out-Null" > nul 2>&1
        if errorlevel 1 (
            echo ���\�[�X�̓W�J�Ɏ��s���܂����B 1>&2
            pause
            exit 1
        )
    )
)
del client.zip
REM "�C���X�g�[���[���_�E�����[�h���Ď��s"
echo �C���X�g�[���[���_�E�����[�h��...
bitsadmin /transfer installer /priority FOREGROUND https://github.com/kyazuki/Minecraft-Modpack-Installer/releases/download/v1.1.2/minecraft-modpack-installer-1.1.2.jar "%CD%\minecraft-modpack-installer.jar" > nul
if errorlevel 1 (
    echo �C���X�g�[���[�̃_�E�����[�h�Ɏ��s���܂����B 1>&2
    pause
    exit 1
)
echo �C���X�g�[����...
java -jar minecraft-modpack-installer.jar