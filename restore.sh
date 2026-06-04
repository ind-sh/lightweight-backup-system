#!/bin/bash

# Get current script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load config
source "$SCRIPT_DIR/config/backup.conf"

# Show available backups
echo "Available backups:"
ls "$BACKUP_DIR"

echo ""

# Ask user for backup name
echo "Enter backup folder name:"
read BACKUP_NAME

# Ask restore destination
echo "Enter restore destination path:"
read RESTORE_PATH

# Create restore directory if missing
mkdir -p "$RESTORE_PATH"

# Restore files
rsync -av "$BACKUP_DIR/$BACKUP_NAME/" "$RESTORE_PATH/"

# Log restore
echo "[$(date)] Restore completed successfully." >> "$LOG_FILE"

echo ""
echo "Restore completed successfully."
