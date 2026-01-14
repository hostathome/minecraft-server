#!/bin/bash
set -e

source /scripts/utils.sh

# Mods are now processed in config.py, so this is a summary stage
log_info "Checking mod configuration..."

# Display mod mode based on environment variables set by config.py
if [ -n "$MODPACK_PLATFORM" ]; then
    log_success "Modpack mode enabled"
    [ -n "$CF_SLUG" ] && log_info "  Modpack: $CF_SLUG"
    [ -n "$CF_FILE_ID" ] && log_info "  Version: Pinned to file ID $CF_FILE_ID"
else
    if [ "$TYPE" = "VANILLA" ] || [ -z "$TYPE" ]; then
        log_success "Vanilla mode (no mods)"
    else
        log_success "Individual mods mode"
        log_info "  Loader: $TYPE"
        [ -n "$CF_MODLIST" ] && log_info "  CurseForge mods: enabled"
        [ -n "$MODRINTH_PROJECTS" ] && log_info "  Modrinth mods: enabled"
    fi
fi
