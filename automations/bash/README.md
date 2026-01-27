# 🔄 NotePlan to Google Drive Sync

This script automates the backup and conversion of your NotePlan md or txt notes. It monitors your local NotePlan notes and calendar entries, converts them into `.docx` format, and syncs them to a designated Google Drive folder.

## 📝 What it does

- **Automated Conversion:** Uses Pandoc to convert Markdown (.md) and text (.txt) files into Microsoft Word (.docx) documents.
- **Smart Sync:** Only processes files that are new or have been modified since the last sync (using file timestamp comparison). This method ensures that new notes are synchronized even if the Mac has been turned off for a longer period of time and changes have been made via the mobile app or web app. Synchronization then takes place as soon as the Mac is restarted. 
- **Header Cleanup:** Automatically strips NotePlan's YAML metadata blocks during conversion for a clean document look.
- **System Safety:** Implements a lock-file mechanism to prevent multiple instances from running at the same time.
- **macOS Notifications:** Sends a native system notification once the backup is successfully completed.

## 💡 Use Case: Semantic Search with Gemini
By keeping your NotePlan notes updated in Google Drive in a readable format (.docx), you unlock powerful AI capabilities:
- **Gemini Integration:** Use the Gemini Google Drive integration to perform semantic searches across your entire NotePlan history.
- **Expert Interaction:** Ask questions like "What were my key insights regarding my marketing strategy last quarter?" and let the AI find the answer in your synced notes.
- **Accessibility:** Access and read your notes on any device via Google Drive, even without the NotePlan app.

## 🛠 Prerequisites

Before running the script, ensure the following tools are installed on your Mac:

1. **Pandoc:** The core engine for file conversion.
   - Install for free via [Homebrew](https://brew.sh): `brew install pandoc`
   - Or directly here: https://pandoc.org/installing.html
2. **Google Drive Desktop:** Ensure Google Drive is installed and the streaming/mirroring location is active.
3. **NotePlan 3:** The script is pre-configured for the standard NotePlan 3 library paths when you use the CloudKit sync option.

## ⚙️ Setup & Configuration

1. **Permissions:** Make the script executable after downloading:
   `chmod +x noteplan-to-gdrive-sync.sh`

2. **Personalization:** Open the script and update the TARGET_ROOT variable with your specific Google Drive path (replace the placeholder YOUR_EMAIL_HERE).

3. **Pandoc Path:** Verify your Pandoc installation path. The script defaults to /usr/local/bin/pandoc. You can check your path by running `which pandoc` in the terminal.
