#!/bin/bash

homeFolder=~

cleanUpFilePath () {
    local rawString=$1
    cleanString=''
    if [[ $1 =~ ["~"] ]]; then
        cleanString=$homeFolder/"${rawString#"~/"}"
    else 
        cleanString=$rawString
    fi
}

# Get user inputs
# If val is missing, complain!
read -p 'SteamCMD Directory: ' cmdLocation
if [ $cmdLocation == "" ]; then
    echo "SteamCMD Directory not specified! Exiting!"
    exit 1
fi

cleanUpFilePath $cmdLocation
cmdLocation=$cleanString

read -p 'CS:GO Directory: ' csLocation
if [ $csLocation == "" ]; then
    echo "CS:GO Directory not specified! Exiting!"
    exit 1
fi
cleanUpFilePath $csLocation
csLocation=$cleanString

# Install basic stuff
sudo apt-get update
sudo apt-get install -y wget
sudo apt-get install -y unzip

# Get architecture
architecture=$(uname -m)
export architecture

# Create all folders if not created yet
if [ ! -d "$cmdLocation" ]; then
    echo "Creating SteamCMD Directory at "$cmdLocation""
    mkdir -p "$cmdLocation"
fi
if [ ! -d "$csLocation" ]; then
    echo "Creating CS:GO Directory at "$csLocation""
    mkdir -p "$csLocation"
fi

# Install tmux to run server in
sudo apt-get install -y tmux

if [[ $architecture == "aarch64" ]]; then
    echo "Cannot install steamCMD as system is running $architecture! Exiting!"
    exit 1
fi

# csgo and steamcmd install
if [[ $architecture == "x86_64" ]]; then
    cd "$cmdLocation"
    sudo apt-get install -y lib32gcc-s1
    sudo apt-get install -y libc6:i386 lsb-core
    sudo apt-get install -y lib32z1
    sudo apt-get install -y ia32-libs
    sudo apt install -y  build-essential
    if [ -e "./steamcmd.sh" ]; then
        ./steamcmd.sh +force_install_dir "$csLocation" +login anonymous +app_update 740 validate +quit
    else
        wget "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz"
        tar zxvf "steamcmd_linux.tar.gz"
        rm -r "steamcmd_linux.tar.gz"
        ./steamcmd.sh +force_install_dir "$csLocation" +login anonymous +app_update 740 validate +quit
    fi
fi
if [[ $architecture == "x86_32" ]]; then
    cd "$cmdLocation"
    sudo apt-get install -y lib32gcc-s1
    sudo apt-get install -y libc6:i386 lsb-core
    sudo apt-get install -y lib32z1
    sudo apt-get install -y ia32-libs
    sudo apt install -y  build-essential
    if [ -e "./steamcmd.sh" ]; then
        ./steamcmd.sh +force_install_dir "$csLocation" +login anonymous +app_update 740 validate +quit
    else
        wget "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz"
        tar zxvf "steamcmd_linux.tar.gz"
        rm -r "steamcmd_linux.tar.gz"
        ./steamcmd.sh +force_install_dir "$csLocation" +login anonymous +app_update 740 validate +quit
    fi
fi

#------------------------
# Mods/Plugin installs
#------------------------

cd "$csLocation/csgo"

# Metamod & Sourcemod installs
wget "https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1148-linux.tar.gz"
tar zxvf "mmsource-1.11.0-git1148-linux.tar.gz"
rm -r "mmsource-1.11.0-git1148-linux.tar.gz"
wget "https://sm.alliedmods.net/smdrop/1.11/sourcemod-1.11.0-git6936-linux.tar.gz"
tar zxvf "sourcemod-1.11.0-git6936-linux.tar.gz"
rm -r "sourcemod-1.11.0-git6936-linux.tar.gz"

#steamworks install
wget "https://github.com/hexa-core-eu/SteamWorks/releases/download/v1.2.4/package-linux.zip"
unzip -o "package-linux.zip"
mv -f "build/package/addons/sourcemod/extensions/SteamWorks.ext.so" "$csLocation/csgo/addons/sourcemod/extensions/SteamWorks.ext.so"
mv -f "build/package/addons/sourcemod/scripting/swag.sp" "$csLocation/csgo/addons/sourcemod/scripting/swag.sp"
mv -f "build/package/addons/sourcemod/scripting/include/SteamWorks.inc" "$csLocation/csgo/addons/sourcemod/scripting/include/SteamWorks.inc"
rm -r "build"
rm "package-linux.zip"

# Splewis installs
wget "https://github.com/splewis/get5/releases/download/v0.15.0/get5-v0.15.0.tar.gz"
tar zxvf "get5-v0.15.0.tar.gz"
rm -r "get5-v0.15.0.tar.gz"
wget "https://ci.splewis.net/job/csgo-practice-mode/lastSuccessfulBuild/artifact/builds/practicemode/practicemode-334.zip"
unzip -o "practicemode-334.zip"
rm -r "practicemode-334.zip"

#Some installations have this problem, renames the conflicting file to allow server to start
cd "$csLocation/bin"
mv libgcc_s.so.1 libgcc_s_old.so.1

echo "All mods installed! Enjoy your server!"