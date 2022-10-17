#!/usr/bin/env bash
set -euo pipefail

#teleport configure -o stdout --roles node --auth-server port.alexeldeib.xyz:443 --token /opt/teleport/token.txt
# tsh login -o identity --proxy port.alexeldeib.xyz
cert="$(tctl --identity identity --auth-server port.alexeldeib.xyz status | rg "CA pin" | tr -s ' ' | cut -d' ' -f3)"
token="$(tctl --identity identity --auth-server port.alexeldeib.xyz tokens add --type=node --ttl=1h | grep -oP '(?<=token:\s).*')"

echo -e "CA pin: $cert\ntoken: $token"
