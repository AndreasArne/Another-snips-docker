#!/usr/bin/env bash
# Unzip assistant and move to config folder

PATH_TO_ZIP="/tmp/assistant_proj_lmxd12oKwv.zip"
PATH_TO_CONF="/media/discworld/git/docker/snips/config"
PATH_TO_ASS="$PATH_TO_CONF/assistant"

if [ -f "$PATH_TO_ZIP" ]; then
    rm -rf "$PATH_TO_ASS"
    sudo unzip "$PATH_TO_ZIP" -d "$PATH_TO_CONF/"

    if [ -d "$PATH_TO_ASS" ]; then
        sudo chmod o+w "$PATH_TO_ASS"
        rm "$PATH_TO_ZIP"
    else
        echo "Assistant directory not in config directory!"
    fi
else
    echo "No Assistant zip at $PATH_TO_ZIP !"
fi
