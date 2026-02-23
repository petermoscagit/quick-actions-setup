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


Developing / Editing the Projects
----------------------------------
After running the setup script, the full source code for both
projects lives on your Mac at:

  ~/Projects/spell-checker/
  ~/Projects/gemini-watermark/

These are full Git repos connected to GitHub. You can edit code,
test, commit, and push from this machine.

  Install an editor (if you don't have one):

    brew install --cask visual-studio-code

  Open a project:

    cd ~/Projects/spell-checker
    code .

  Activate the virtual environment before running or testing:

    source venv/bin/activate
    python -m spellcheck sample.png          # spell-checker
    gemini-watermark remove some-image.png   # watermark tool

  After making changes, commit and push:

    git add <files-you-changed>
    git commit -m "Describe what you changed"
    git push

  Pull the latest changes (e.g. edits made on another Mac):

    cd ~/Projects/spell-checker && git pull
    cd ~/Projects/gemini-watermark && git pull

  Re-run the setup script to update Quick Actions after code
  changes (it will pull latest and reinstall):

    zsh ~/Downloads/setup-quick-actions.sh


Project Reference
-----------------
spell-checker:
  Source:     ~/Projects/spell-checker/src/spellcheck/
  Dictionary: ~/Projects/spell-checker/dictionaries/servicenow-aerospace.txt
  Config:     ~/Projects/spell-checker/cspell.json
  Run:        source venv/bin/activate && python -m spellcheck <file>

gemini-watermark:
  Source:     ~/Projects/gemini-watermark/src/gemini_watermark/
  Run:        source venv/bin/activate && gemini-watermark remove <file>

GitHub Repos:
  https://github.com/petermoscagit/spell-checker
  https://github.com/petermoscagit/gemini-watermark
  https://github.com/petermoscagit/quick-actions-setup
