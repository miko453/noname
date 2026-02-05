#!/bin/bash

# Use sudo to ensure correct ownership of the home directory
sudo chown -R qwe:qwe /config

# Set VNC password and xstartup only if the password file doesn't exist
if [ ! -f "/config/.vnc/passwd" ]; then
    echo "Setting up VNC for the first time..."

    # Set VNC password from environment variable, with a default
    VNC_PASSWORD=${VNC_PASSWORD:-114514}

    # Create .vnc directory and set the password
    mkdir -p /config/.vnc
    echo "$VNC_PASSWORD" | vncpasswd -f > /config/.vnc/passwd
    chmod 600 /config/.vnc/passwd

    # Create the xstartup file for XFCE4
    cat <<'EOF' > /config/.vnc/xstartup
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
/usr/bin/startxfce4
EOF
    chmod +x /config/.vnc/xstartup
else
    echo "VNC setup already found. Skipping."
fi
