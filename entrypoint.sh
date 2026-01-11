#!/bin/bash
set -e

# Copy default config if missing or placeholder
if [ ! -f /configs/config.yaml ] || grep -q "This will be replaced" /configs/config.yaml 2>/dev/null; then
    echo "HostAtHome: Copying default config.yaml..."
    cp /defaults/config.yaml /configs/config.yaml
fi

# Copy default mods config if missing
if [ ! -f /configs/mods.yaml ]; then
    echo "HostAtHome: Copying default mods.yaml..."
    cp /defaults/mods.yaml /configs/mods.yaml
fi

echo "HostAtHome: Using configuration from /configs/"

# Generate server.properties from YAML
echo "HostAtHome: Generating server.properties from config.yaml..."
python3 /config_mapper.py /configs/config.yaml > /data/server.properties

# Load environment variables from config.yaml
echo "HostAtHome: Loading environment variables from config.yaml..."
eval "$(python3 /config_mapper.py /configs/config.yaml --env)"

# Apply mods configuration
if [ -f /configs/mods.yaml ]; then
    echo "HostAtHome: Processing mods configuration..."
    eval "$(python3 /config_mapper.py /configs/mods.yaml --mods)"
fi

# Tell itzg to use our properties
export OVERRIDE_SERVER_PROPERTIES=false
export SKIP_SERVER_PROPERTIES=true

# Log configuration mode
echo ""
echo "HostAtHome Configuration:"
if [ -n "$MODPACK_PLATFORM" ]; then
    echo "  Mode: Modpack ($CF_SLUG)"
    if [ -n "$CF_FILE_ID" ]; then
        echo "  Version: Pinned to file ID $CF_FILE_ID"
    fi
else
    echo "  Mode: Individual mods"
    echo "  Loader: ${TYPE:-VANILLA}"
fi
[ -n "$MEMORY" ] && echo "  Memory: $MEMORY"
[ -n "$CF_API_KEY" ] && echo "  CurseForge: enabled"
[ -n "$MODRINTH_PROJECTS" ] && echo "  Modrinth: enabled"
echo ""

exec /start
