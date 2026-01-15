#!/bin/bash
set -e

# Source utilities for consistent logging
source /scripts/utils.sh

# Execute setup stage
log_stage "Setup"
/scripts/setup.sh

# Execute configuration stage: convert YAML → environment variables
log_stage "Configuration"
eval "$(python3 /scripts/config.py)"

# Execute logging/summary stage
log_stage "Summary"
/scripts/logging.sh

# Hand off to itzg minecraft container
exec /image/scripts/start
