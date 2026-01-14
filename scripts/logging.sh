#!/bin/bash
set -e

source /scripts/utils.sh

echo ""
echo "=========================================="
echo "  HostAtHome - Minecraft Server"
echo "=========================================="
echo ""
echo "Server Configuration:"
[ -n "$VERSION" ] && echo "  Version: $VERSION"
[ -n "$MEMORY" ] && echo "  Memory: $MEMORY"
[ -n "$MAX_PLAYERS" ] && echo "  Max Players: $MAX_PLAYERS"
[ -n "$GAMEMODE" ] && echo "  Gamemode: $GAMEMODE"
[ -n "$DIFFICULTY" ] && echo "  Difficulty: $DIFFICULTY"
[ -n "$LEVEL_TYPE" ] && echo "  World Type: $LEVEL_TYPE"
echo ""

if [ -n "$MODPACK_PLATFORM" ]; then
    echo "Mod Configuration:"
    echo "  Mode: Modpack"
    [ -n "$CF_SLUG" ] && echo "  Pack: $CF_SLUG"
    [ -n "$CF_FILE_ID" ] && echo "  Version: File ID $CF_FILE_ID"
else
    echo "Mod Configuration:"
    if [ -n "$TYPE" ] && [ "$TYPE" != "VANILLA" ]; then
        echo "  Mode: Individual Mods"
        echo "  Loader: $TYPE"
    else
        echo "  Mode: Vanilla (no mods)"
    fi
fi

echo ""
echo "Starting server..."
echo "=========================================="
echo ""
