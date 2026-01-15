#!/bin/bash
set -e

source /scripts/utils.sh

log_info "Initializing file structure..."

# Ensure required directories exist
ensure_dir /configs
ensure_dir /data

# Copy default config.yaml if missing or placeholder
if copy_if_missing /defaults/config.yaml /configs/config.yaml; then
    log_success "Installed default config.yaml"
elif copy_if_placeholder /defaults/config.yaml /configs/config.yaml; then
    log_success "Replaced placeholder config.yaml"
else
    log_success "Using existing config.yaml"
fi

# Copy default mods.yaml if missing
if copy_if_missing /defaults/mods.yaml /configs/mods.yaml; then
    log_success "Installed default mods.yaml"
else
    log_success "Using existing mods.yaml"
fi

# Validate required files exist
validate_file /configs/config.yaml
validate_file /configs/mods.yaml

log_success "Setup complete"
