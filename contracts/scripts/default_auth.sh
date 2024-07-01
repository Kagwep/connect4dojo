#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..

export WORLD_ADDRESS="0x43ddbff1c3e0e80e9ca57b47d6a17b078fc0b7257536d74a4a05a42a46fc946";

need_cmd() {
    if ! check_cmd "$1"; then
        printf "need '$1' (command not found)"
        exit 1
    fi
}

check_cmd(){
    command -v "$1" &>/dev/null
}


need_cmd jq

export RPC_URL="http://localhost:5050";


echo "---------------------------------------------------------------------------"
echo world : $WORLD_ADDRESS 

echo "---------------------------------------------------------------------------"

sozo auth grant --world $WORLD_ADDRESS --wait writer \
 Player,bootcamp::systems::actions::actions\
 Tile,bootcamp::systems::actions::actions\
 >/dev/null

 echo "Default authorizations have been successfully set."