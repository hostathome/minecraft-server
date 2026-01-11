#!/bin/bash
set -e

# Ensure directories exist
mkdir -p /data/data /data/configs

# Copy default config if missing
if [ ! -f /data/configs/config.yaml ]; then
    echo "HostAtHome: No config found, using built-in defaults..."
    cp /defaults/config.yaml /data/configs/
else
    echo "HostAtHome: Using mounted configuration from /data/configs/config.yaml"
fi

# Copy default mods config if missing
if [ ! -f /data/configs/mods.yaml ]; then
    echo "HostAtHome: No mods config found, using built-in defaults..."
    cp /defaults/mods.yaml /data/configs/
else
    echo "HostAtHome: Using mounted mods configuration"
fi

# Change to data directory - all runtime files (world, jars, libs, logs) go here
cd /data/data

# Generate server.properties from YAML
echo "HostAtHome: Generating server.properties from config.yaml..."
python3 /config_mapper.py /data/configs/config.yaml > ./server.properties

# Apply mods configuration
echo "HostAtHome: Applying mods configuration..."
if [ -f /data/configs/mods.yaml ]; then
    eval "$(python3 /config_mapper.py /data/configs/mods.yaml --mods)"
fi

# Tell itzg to use our properties
export OVERRIDE_SERVER_PROPERTIES=false
export SKIP_SERVER_PROPERTIES=true

echo "Starting Minecraft..."
echo "Loader: ${TYPE:-VANILLA}"
exec /start
