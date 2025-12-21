#!/bin/bash
set -e

# Copy defaults if missing
[ ! -f /data/configs/config.yaml ] && cp /defaults/config.yaml /data/configs/
[ ! -f /data/mods/mods.yaml ] && cp /defaults/mods.yaml /data/mods/

# Symlink folders to itzg's expected locations
ln -sfn /data/save /data/world
ln -sfn /data/mods /data/plugins 2>/dev/null || true

# Generate server.properties from YAML
CONFIG=/data/configs/config.yaml
cat > /data/server.properties << EOF
motd=$(yq '.server.motd' $CONFIG)
max-players=$(yq '.server.max-players' $CONFIG)
gamemode=$(yq '.server.gamemode' $CONFIG)
difficulty=$(yq '.server.difficulty' $CONFIG)
hardcore=$(yq '.server.hardcore' $CONFIG)
pvp=$(yq '.server.pvp' $CONFIG)
level-type=$(yq '.world.type' $CONFIG)
level-seed=$(yq '.world.seed' $CONFIG)
view-distance=$(yq '.world.view-distance' $CONFIG)
spawn-protection=$(yq '.world.spawn-protection' $CONFIG)
online-mode=$(yq '.network.online-mode' $CONFIG)
white-list=$(yq '.network.white-list' $CONFIG)
EOF

# Apply mods from mods.yaml
MODS=/data/mods/mods.yaml

# Set mod loader
LOADER=$(yq '.loader // "vanilla"' $MODS)
export TYPE=${LOADER^^}

# CurseForge
CF_KEY=$(yq '.curseforge.api-key // ""' $MODS)
if [ -n "$CF_KEY" ] && [ "$CF_KEY" != "null" ]; then
    export CF_API_KEY="$CF_KEY"
    CF_MODS=$(yq '.curseforge.mods | join(",")' $MODS)
    [ -n "$CF_MODS" ] && [ "$CF_MODS" != "null" ] && export CF_SLUG="$CF_MODS"
fi

# Modrinth
MR_MODS=$(yq '.modrinth | join(",")' $MODS 2>/dev/null)
if [ -n "$MR_MODS" ] && [ "$MR_MODS" != "null" ]; then
    export MODRINTH_PROJECTS="$MR_MODS"
fi

# Tell itzg to use our properties
export OVERRIDE_SERVER_PROPERTIES=false
export SKIP_SERVER_PROPERTIES=true

echo "Starting Minecraft..."
echo "Loader: $LOADER"
exec /start
