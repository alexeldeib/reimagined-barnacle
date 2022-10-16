#!/usr/bin/env bash
set -euo pipefail
flyctl deploy
flyctl ssh console -C "/opt/teleport/post-deploy.sh"
