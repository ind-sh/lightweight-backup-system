#!/bin/bash

# Get current script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load configuration file
source "$SCRIPT_DIR/config/backup.conf"

# Generate timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Create backup folder path
CURRENT_BACKUP="$BACKUP_DIR/$TIMESTAMP"

# Create backup directory
mkdir -p "$CURRENT_BACKUP"

# Log backup start
echo "[$(date)] Backup process started." >> "$LOG_FILE"

# Run incremental backup using rsync
# > /dev/null hides unnecessary rsync output
# 2>&1 captures errors only
rsync -a --delete "$SOURCE_DIR/" "$CURRENT_BACKUP/" > /dev/null 2>&1

# Check backup status
if [ $? -eq 0 ]; then
    echo "[$(date)] Backup completed successfully." >> "$LOG_FILE"
else
    echo "[$(date)] ERROR: Backup failed." >> "$LOG_FILE"
    exit 1
fi
