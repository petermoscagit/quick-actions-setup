Quick Actions Setup — Instructions
===================================

This folder contains a setup script that installs two macOS Finder
Quick Actions on a new Mac:

  - Spell Check Infographic  (right-click PNG/PDF files)
  - Remove Gemini Watermark  (right-click image files)


Prerequisites
-------------
Homebrew must be installed. If it isn't, open Terminal and run:

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

You'll also need your GitHub credentials (the script will open a
browser window for authentication).


Setup Steps
-----------
1. Download both files from this Google Drive folder to your
   Downloads folder (or anywhere convenient).

2. Open Terminal (Applications > Utilities > Terminal).

3. Run these two commands:

     chmod +x ~/Downloads/setup-quick-actions.sh
     zsh ~/Downloads/setup-quick-actions.sh

   (If you saved to a different folder, adjust the path.)

4. The script will:
   - Install system dependencies (tesseract, node, gh)
   - Prompt you to log in to GitHub (opens browser)
   - Clone both project repos to ~/Projects/
   - Create Python virtual environments and install packages
   - Generate and register both Quick Actions

5. When it finishes you'll see "Setup Complete". If the Quick
   Actions don't appear when you right-click files in Finder, run:

     killall Finder


Using the Quick Actions
-----------------------
Spell Check Infographic:
  Right-click a PNG or PDF in Finder > Quick Actions >
  Spell Check Infographic. A browser window opens for review,
  and a CSV report is saved next to the original file.

Remove Gemini Watermark:
  Right-click one or more image files (PNG, JPG, JPEG, WEBP) in
  Finder > Quick Actions > Remove Gemini Watermark. Cleaned copies
  are saved as <filename>_cleaned.<ext> in the same folder.
