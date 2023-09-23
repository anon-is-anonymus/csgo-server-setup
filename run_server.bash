#!/bin/bash

# Get user inputs
read -p 'CS:GO Directory: ' csLocation
read -p 'CS:GO Port (Default: 27015): | Leave blank if not needed ' csPort
read -p 'GOTV Port (Default: 27020): | Leave blank if not needed ' gotvPort
read -p 'RCON Password: | Leave blank if not needed ' rconPass
read -p 'Server Password: | Leave blank if not needed ' serverPass
read -p 'Game Server Token (See https://steamcommunity.com/dev/managegameservers): ' gameToken

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

# If no val specified, set to defaults
if [ -z $csPort ]; then
    csPort=27015
fi
if [ -z $gotvPort]; then
    gotvPort=27020
fi

cleanUpFilePath $csLocation
csLocation=$cleanString

# Start server
tmux new-session -s "CSGO_Server" -d "cd $csLocation && ./srcds_run -game csgo -console -tickrate 128 -sv_mincmdrate 128 -sv_minupdaterate 128 -port $csPort +rcon_password $rconPass +sv_password $serverPass +sv_setsteamaccount $gameToken +tv_port $gotvPort +game_type 0 +game_mode 1 +mapgroup mg_active +map de_dust2"
echo TMUX Server started!