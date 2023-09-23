#!/bin/bash

# Get user inputs
read -p 'SteamCMD Directory: ' cmdLocation
read -p 'CS:GO Directory: ' csLocation

cd "$cmdLocation"
./steamcmd.sh +force_install_dir "$csLocation" +login anonymous +app_update 740 validate +quit

echo "CS:GO Server updated! Get5 and Practice Mode are not updated as they are EOL."