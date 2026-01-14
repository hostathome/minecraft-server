#!/bin/bash
# HostAtHome Shared Utilities
# Common logging, file operations, and validation functions

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[HostAtHome]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[HostAtHome]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[HostAtHome]${NC} $1"
}

log_error() {
    echo -e "${RED}[HostAtHome ERROR]${NC} $1" >&2
}

log_stage() {
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  $1${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
}

# File operations
ensure_dir() {
    local dir=$1
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        log_info "Created directory: $dir"
    fi
}

copy_if_missing() {
    local src=$1
    local dest=$2
    if [ ! -f "$dest" ]; then
        log_info "Copying default: $(basename $dest)"
        cp "$src" "$dest"
        chown 1000:1000 "$dest" 2>/dev/null || true
        chmod 666 "$dest"
        return 0
    else
        return 1
    fi
}

copy_if_placeholder() {
    local src=$1
    local dest=$2
    if grep -q "This will be replaced" "$dest" 2>/dev/null; then
        log_info "Replacing placeholder: $(basename $dest)"
        cp "$src" "$dest"
        chown 1000:1000 "$dest" 2>/dev/null || true
        chmod 666 "$dest"
        return 0
    else
        return 1
    fi
}

# Validation
validate_file() {
    local file=$1
    if [ ! -f "$file" ]; then
        log_error "Required file not found: $file"
        exit 1
    fi
}
