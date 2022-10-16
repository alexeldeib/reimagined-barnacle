#!/usr/bin/env bash
set -euo pipefail
/usr/local/bin/tctl create -f /opt/teleport/sso-role.yaml 
/usr/local/bin/tctl create -f /opt/teleport/github.yaml 
/usr/local/bin/tctl create -f /opt/teleport/cap.yaml
