#!/bin/bash

# Run the VNC setup script
bash /app/rootlessvnc.sh

# Start the VNC server
vncserver -geometry 1920x1080 -depth 24 -localhost no

# Keep the container running
tail -f /dev/null
