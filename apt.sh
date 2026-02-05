#!/bin/bash

case "$1" in
    "switch")
        echo "Switching to temporary mirror: mirrors.7.b.0.5.0.7.4.0.1.0.0.2.ip6.arpa/system/kali"
        # Backup original sources.list if it exists and backup doesn't
        if [ -f /etc/apt/sources.list ] && [ ! -f /etc/apt/sources.list.bak ]; then
            mv /etc/apt/sources.list /etc/apt/sources.list.bak
        fi
        # Create new sources.list
        echo "deb http://mirrors.7.b.0.5.0.7.4.0.1.0.0.2.ip6.arpa/system/kali kali-rolling main non-free contrib" > /etc/apt/sources.list
        ;;
    "restore")
        echo "Restoring original APT sources..."
        # Restore from backup if it exists
        if [ -f /etc/apt/sources.list.bak ]; then
            mv /etc/apt/sources.list.bak /etc/apt/sources.list
        fi
        ;;
    *)
        echo "Usage: $0 {switch|restore}"
        exit 1
        ;;
esac
