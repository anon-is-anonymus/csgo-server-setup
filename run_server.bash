#!/bin/bash

# Get user inputs
read -p 'CS:GO Directory: ' csLocation
read -p 'CS:GO Port (Default: 27015): | Leave blank if not needed' csPort
read -P 'GOTV Port (Default: 27020): | Leave blank if not needed' gotvPort
read -P 'RCON Password: | Leave blank if not needed' rconPass
read -p 'Server Password: | Leave blank if not needed' serverPass
read -P 'Game Server Token' gameToken

# If no val specified, set to defaults
if [csPort == ""]; then
    csPort = 27015
fi
if [gotvPort == ""]; then
    gotvPort = 27020
fi

# Start server
tmux new -s "CSGO_Server" -d "cd $csLocation && './srcds_run -game csgo -console -port $csPort +rcon_password $rconPass +sv_password $serverPass +sv_setsteamaccount $gameToken +tv_port $gotvPort +game_type 0 +game_mode 1 +mapgroup mg_active +map de_dust2'"