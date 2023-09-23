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

cd "$cmdLocation"
./steamcmd.sh +force_install_dir "$csLocation" +login anonymous +app_update 740 validate +quit

echo "CS:GO Server updated! Get5 and Practice Mode are not updated as they are EOL."