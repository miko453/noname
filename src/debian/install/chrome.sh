#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo "Install Google Chrome"
apt install -y chromium
