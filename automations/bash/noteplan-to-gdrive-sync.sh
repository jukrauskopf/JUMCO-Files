#!/bin/bash

# --- CONFIGURATION ---
# NotePlan source directories for Notes and Calendar entries when synced with CloudKit
SOURCE_DIRS=(
    "$HOME/Library/Containers/co.noteplan.NotePlan3/Data/Library/Application Support/co.noteplan.NotePlan3/Notes"
    "$HOME/Library/Containers/co.noteplan.NotePlan3/Data/Library/Application Support/co.noteplan.NotePlan3/Calendar"
)

# TARGET_ROOT: Path to your Google Drive or Cloud Storage. 
# Placeholder used for privacy. Replace with your actual path.
TARGET_ROOT="$HOME/Library/CloudStorage/GoogleDrive-YOUR_EMAIL_HERE/My Drive/NotePlan_Backup"

LOG_FILE="$HOME/noteplan_sync_log.txt"
LOCK_FILE="/tmp/noteplan_sync.lock"
NOTIFY_FLAG="/tmp/noteplan_updated_flag"

# --- TOOLS ---
# Path to the Pandoc executable
PANDOC_CMD="/usr/local/bin/pandoc"

# --- LOCK FILE HANDLING ---
# Prevents multiple instances from running simultaneously.
# If a lock file is older than 1 minute, it is considered stale and removed.
if [ -f "$LOCK_FILE" ]; then
    if [ "$(find "$LOCK_FILE" -mmin +1)" ]; then
        rm "$LOCK_FILE"
    else
        # Process already running, exiting.
        exit 0
    fi
fi
touch "$LOCK_FILE"

# --- MAIN SYNC LOOP ---
for SRC in "${SOURCE_DIRS[@]}"; do
    if [ ! -d "$SRC" ]; then continue; fi
    
    folder_name=$(basename "$SRC")

    # Finding all .md and .txt files
    find "$SRC" \( -name "*.md" -o -name "*.txt" \) -type f | while read f; do
        
        rel_path="${f#$SRC/}"
        # Convert file extension to .docx for the backup
        base_name="${rel_path%.*}"
        out_path="$TARGET_ROOT/$folder_name/${base_name}.docx"
        
        # COMPARISON: Is the source file newer than the backup?
        if [ ! -f "$out_path" ] || [ "$f" -nt "$out_path" ]; then
            
            mkdir -p "$(dirname "$out_path")"
            
            # PANDOC TRICK: -f markdown-yaml_metadata_block
            # This tells Pandoc to ignore the NotePlan YAML header during conversion.
            if "$PANDOC_CMD" -f markdown-yaml_metadata_block "$f" -o "$out_path"; then
                echo "$(date): UPDATE [$folder_name] $rel_path" >> "$LOG_FILE"
                touch "$NOTIFY_FLAG"
            else
                # Logging errors if conversion fails
                echo "$(date): ERROR processing $rel_path" >> "$LOG_FILE"
            fi
        fi
    done
done

rm "$LOCK_FILE"

# --- NOTIFICATION ---
# Triggers a macOS system notification if any files were updated.
if [ -f "$NOTIFY_FLAG" ]; then
    osascript -e 'display notification "NotePlan backup updated successfully." with title "JUMCO Sync"'
    rm "$NOTIFY_FLAG"
fi
