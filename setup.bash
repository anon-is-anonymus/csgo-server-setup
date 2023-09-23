#!/bin/bash

# Get user inputs
# If val is missing, complain!
read -p 'SteamCMD Directory: ' cmdLocation
if [$cmdLocation == ""]; then
    echo "SteamCMD Directory not specified! Exiting"
    exit 1
fi

read -p 'CS:GO Directory: ' csLocation
if [$csLocation == ""]; then
    echo "CS:GO Directory not specified! Exiting"
    exit 1
fi

# Install basic stuff
sudo apt-get install -y wget
sudo apt-get install -y unzip

# Get architecture
architecture=$(uname -m)

# Create all folders if not created yet
if [ ! -d "$cmdLocation" ]; then
    echo "Creating SteamCMD Directory at "$cmdLocation""
    mkdir "$cmdLocation"
fi
if [ ! -d "$csLocation" ]; then
    echo "Creating CS:GO Directory at "$csLocation""
    mkdir "$csLocation"
fi

# Install tmux to run server in
sudo apt-get install -y tmux

if [$architecture != "x86_64"] || [architecture != "x86_32"]; then
    echo "Cannot install steamCMD as system is running $architecture! Exiting!"
    exit 1
fi

# csgo and steamcmd install
if [$architecture == "x86_64"]; then
    sudo apt-get install -y lib32gcc-s1
    cd "$cmdLocation"
    wget "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
    rm -r "steamcmd_linux.tar.gz"
    ./steamcmd.sh +force_install_dir "$csLocation" +login anonymous +app_update 740 validate +quit
fi

#------------------------
# Mods/Plugin installs
#------------------------

cd "$csLocation"
# Metamod & Sourcemod installs
wget "https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1148-linux.tar.gz" | tar zxvfr "mmsource-1.11.0-git1148-linux.tar.gz"
wget "https://sm.alliedmods.net/smdrop/1.11/sourcemod-1.11.0-git6936-linux.tar.gz" | tar zxvfr "sourcemod-1.11.0-git6936-linux.tar.gz"

# Splewis installs
wget "https://github.com/splewis/get5/releases/download/v0.15.0/get5-v0.15.0.tar.gz" | tar zxvfr "get5-v0.15.0.tar.gz"
wget "https://ci.splewis.net/job/csgo-practice-mode/lastSuccessfulBuild/artifact/builds/practicemode/practicemode-334.zip" | unzip -o "practicemode-334.zip"

echo "All mods installed! Enjoy your server!"