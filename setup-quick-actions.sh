#!/bin/zsh
# ============================================================
# Quick Actions Setup for macOS
# Run this on your other Mac to install both Quick Actions.
# ============================================================
set -e

echo "=== Quick Actions Setup ==="
echo ""

# --- Prerequisites ---
echo "Checking prerequisites..."

if ! command -v brew &>/dev/null; then
    echo "ERROR: Homebrew not found. Install it first:"
    echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    exit 1
fi

# Install system deps
echo "Installing system dependencies..."
brew install tesseract node gh 2>/dev/null || true

# Verify
command -v tesseract &>/dev/null || { echo "ERROR: tesseract not found"; exit 1; }
command -v node &>/dev/null || { echo "ERROR: node not found"; exit 1; }
command -v npx &>/dev/null || { echo "ERROR: npx not found"; exit 1; }
echo "  tesseract: $(tesseract --version 2>&1 | head -1)"
echo "  node: $(node --version)"
echo ""

# --- GitHub auth ---
if ! gh auth status &>/dev/null 2>&1; then
    echo "GitHub CLI not authenticated. Logging in..."
    gh auth login --web --git-protocol https
    gh auth setup-git
fi

# --- Clone and set up spell-checker ---
echo "Setting up spell-checker..."
SPELL_DIR="$HOME/Projects/spell-checker"
if [[ -d "$SPELL_DIR" ]]; then
    echo "  Already exists at $SPELL_DIR, pulling latest..."
    git -C "$SPELL_DIR" pull
else
    mkdir -p "$HOME/Projects"
    gh repo clone petermoscagit/spell-checker "$SPELL_DIR"
fi

python3 -m venv "$SPELL_DIR/venv"
source "$SPELL_DIR/venv/bin/activate"
pip install -e "$SPELL_DIR" --quiet
deactivate
echo "  Done."
echo ""

# --- Clone and set up gemini-watermark ---
echo "Setting up gemini-watermark..."
WM_DIR="$HOME/Projects/gemini-watermark"
if [[ -d "$WM_DIR" ]]; then
    echo "  Already exists at $WM_DIR, pulling latest..."
    git -C "$WM_DIR" pull
else
    mkdir -p "$HOME/Projects"
    gh repo clone petermoscagit/gemini-watermark "$WM_DIR"
fi

python3 -m venv "$WM_DIR/venv"
source "$WM_DIR/venv/bin/activate"
pip install -e "$WM_DIR" --quiet
deactivate
echo "  Done."
echo ""

# --- Install Spell Check Infographic Quick Action ---
echo "Installing Quick Action: Spell Check Infographic..."
QA_DIR="$HOME/Library/Services/Spell Check Infographic.workflow/Contents"
mkdir -p "$QA_DIR"

# Write the workflow plist template
cat > "$QA_DIR/document.wflow" << 'WFLOW_EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>AMApplicationBuild</key>
	<string>527</string>
	<key>AMApplicationVersion</key>
	<string>2.10</string>
	<key>AMDocumentVersion</key>
	<string>2</string>
	<key>actions</key>
	<array>
		<dict>
			<key>action</key>
			<dict>
				<key>AMAccepts</key>
				<dict>
					<key>Container</key>
					<string>List</string>
					<key>Optional</key>
					<true/>
					<key>Types</key>
					<array>
						<string>com.apple.cocoa.string</string>
					</array>
				</dict>
				<key>AMActionVersion</key>
				<string>2.0.3</string>
				<key>AMApplication</key>
				<array>
					<string>Automator</string>
				</array>
				<key>AMParameterProperties</key>
				<dict>
					<key>COMMAND_STRING</key>
					<dict/>
					<key>CheckedForUserDefaultShell</key>
					<dict/>
					<key>inputMethod</key>
					<dict/>
					<key>shell</key>
					<dict/>
					<key>source</key>
					<dict/>
				</dict>
				<key>AMProvides</key>
				<dict>
					<key>Container</key>
					<string>List</string>
					<key>Types</key>
					<array>
						<string>com.apple.cocoa.string</string>
					</array>
				</dict>
				<key>ActionBundlePath</key>
				<string>/System/Library/Automator/Run Shell Script.action</string>
				<key>ActionName</key>
				<string>Run Shell Script</string>
				<key>ActionParameters</key>
				<dict>
					<key>COMMAND_STRING</key>
					<string>PLACEHOLDER</string>
					<key>CheckedForUserDefaultShell</key>
					<true/>
					<key>inputMethod</key>
					<integer>1</integer>
					<key>shell</key>
					<string>/bin/zsh</string>
					<key>source</key>
					<string></string>
				</dict>
				<key>BundleIdentifier</key>
				<string>com.apple.RunShellScript</string>
				<key>CFBundleVersion</key>
				<string>2.0.3</string>
				<key>CanShowSelectedItemsWhenRun</key>
				<false/>
				<key>CanShowWhenRun</key>
				<true/>
				<key>Category</key>
				<array>
					<string>AMCategoryUtilities</string>
				</array>
				<key>Class Name</key>
				<string>RunShellScriptAction</string>
				<key>InputUUID</key>
				<string>A1B2C3D4-E5F6-7890-ABCD-EF1234567890</string>
				<key>Keywords</key>
				<array>
					<string>Shell</string>
					<string>Script</string>
					<string>Command</string>
					<string>Run</string>
					<string>Unix</string>
				</array>
				<key>OutputUUID</key>
				<string>B2C3D4E5-F6A7-8901-BCDE-F12345678901</string>
				<key>UUID</key>
				<string>C3D4E5F6-A7B8-9012-CDEF-123456789012</string>
				<key>UnlocalizedApplications</key>
				<array>
					<string>Automator</string>
				</array>
				<key>arguments</key>
				<dict>
					<key>0</key>
					<dict>
						<key>default value</key>
						<integer>0</integer>
						<key>name</key>
						<string>inputMethod</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>0</string>
					</dict>
					<key>1</key>
					<dict>
						<key>default value</key>
						<false/>
						<key>name</key>
						<string>CheckedForUserDefaultShell</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>1</string>
					</dict>
					<key>2</key>
					<dict>
						<key>default value</key>
						<string></string>
						<key>name</key>
						<string>source</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>2</string>
					</dict>
					<key>3</key>
					<dict>
						<key>default value</key>
						<string></string>
						<key>name</key>
						<string>COMMAND_STRING</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>3</string>
					</dict>
					<key>4</key>
					<dict>
						<key>default value</key>
						<string>/bin/sh</string>
						<key>name</key>
						<string>shell</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>4</string>
					</dict>
				</dict>
				<key>isViewVisible</key>
				<integer>1</integer>
				<key>location</key>
				<string>309.000000:630.000000</string>
				<key>nibPath</key>
				<string>/System/Library/Automator/Run Shell Script.action/Contents/Resources/Base.lproj/main.nib</string>
			</dict>
			<key>isViewVisible</key>
			<integer>1</integer>
		</dict>
	</array>
	<key>connectors</key>
	<dict/>
	<key>workflowMetaData</key>
	<dict>
		<key>applicationBundleID</key>
		<string>com.apple.finder</string>
		<key>applicationBundleIDsByPath</key>
		<dict>
			<key>/System/Library/CoreServices/Finder.app</key>
			<string>com.apple.finder</string>
		</dict>
		<key>applicationPath</key>
		<string>/System/Library/CoreServices/Finder.app</string>
		<key>applicationPaths</key>
		<array>
			<string>/System/Library/CoreServices/Finder.app</string>
		</array>
		<key>inputTypeIdentifier</key>
		<string>com.apple.Automator.fileSystemObject</string>
		<key>outputTypeIdentifier</key>
		<string>com.apple.Automator.nothing</string>
		<key>presentationMode</key>
		<integer>15</integer>
		<key>processesInput</key>
		<false/>
		<key>serviceApplicationBundleID</key>
		<string>com.apple.finder</string>
		<key>serviceApplicationPath</key>
		<string>/System/Library/CoreServices/Finder.app</string>
		<key>serviceInputTypeIdentifier</key>
		<string>com.apple.Automator.fileSystemObject</string>
		<key>serviceOutputTypeIdentifier</key>
		<string>com.apple.Automator.nothing</string>
		<key>serviceProcessesInput</key>
		<false/>
		<key>systemImageName</key>
		<string>NSActionTemplate</string>
		<key>useAutomaticInputType</key>
		<false/>
		<key>workflowTypeIdentifier</key>
		<string>com.apple.Automator.servicesMenu</string>
	</dict>
</dict>
</plist>
WFLOW_EOF

# Write the spell-check shell script to a temp file (avoids quoting issues)
SPELL_SCRIPT_FILE=$(mktemp)
cat > "$SPELL_SCRIPT_FILE" << SPELL_SCRIPT_EOF
# Spell Check Infographic — Quick Action
export PATH="/opt/homebrew/bin:/usr/local/bin:\$PATH"

PROJECT_DIR="$SPELL_DIR"

if [[ -z "\$1" ]]; then
    osascript -e 'display notification "No file provided." with title "Spell Check"'
    exit 1
fi

# Validate extension
ext="\${1##*.}"
ext_lower="\$(echo "\$ext" | tr '[:upper:]' '[:lower:]')"
if [[ "\$ext_lower" != "png" && "\$ext_lower" != "pdf" ]]; then
    osascript -e "display notification \"Unsupported file type: \$ext_lower. Use PNG or PDF.\" with title \"Spell Check\""
    exit 1
fi

source "\$PROJECT_DIR/venv/bin/activate"
cd "\$PROJECT_DIR"

for f in "\$@"; do
    input_dir="\$(dirname "\$f")"
    input_base="\$(basename "\${f%.*}")"
    output_csv="\${input_dir}/\${input_base}_spellcheck.csv"

    osascript -e "display notification \"Running spell check on \$(basename "\$f")…\" with title \"Spell Check\""

    python -m spellcheck "\$f" -o "\$output_csv"
done

osascript -e 'display notification "Spell check complete." with title "Spell Check"'
SPELL_SCRIPT_EOF

# Inject the shell script into the plist using Python + temp file
python3 << PYEOF
import plistlib

with open("$SPELL_SCRIPT_FILE") as sf:
    script = sf.read()

wflow = "$QA_DIR/document.wflow"
with open(wflow, "rb") as f:
    plist = plistlib.load(f)

plist["actions"][0]["action"]["ActionParameters"]["COMMAND_STRING"] = script

with open(wflow, "wb") as f:
    plistlib.dump(plist, f)
PYEOF
rm -f "$SPELL_SCRIPT_FILE"

# Write the Info.plist
cat > "$QA_DIR/Info.plist" << 'PLIST_EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>NSServices</key>
	<array>
		<dict>
			<key>NSBackgroundColorName</key>
			<string>background</string>
			<key>NSIconName</key>
			<string>NSActionTemplate</string>
			<key>NSMenuItem</key>
			<dict>
				<key>default</key>
				<string>Spell Check Infographic</string>
			</dict>
			<key>NSMessage</key>
			<string>runWorkflowAsService</string>
			<key>NSRequiredContext</key>
			<dict>
				<key>NSApplicationIdentifier</key>
				<string>com.apple.finder</string>
			</dict>
			<key>NSSendFileTypes</key>
			<array>
				<string>public.image</string>
				<string>com.adobe.pdf</string>
			</array>
		</dict>
	</array>
</dict>
</plist>
PLIST_EOF

echo "  Installed."

# --- Install Remove Gemini Watermark Quick Action ---
echo "Installing Quick Action: Remove Gemini Watermark..."
WM_QA_DIR="$HOME/Library/Services/Remove Gemini Watermark.workflow/Contents"
mkdir -p "$WM_QA_DIR"

WM_CMD="$WM_DIR/venv/bin/gemini-watermark"

# Write the workflow plist template (same structure, reuse)
cat > "$WM_QA_DIR/document.wflow" << 'WFLOW_EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>AMApplicationBuild</key>
	<string>527</string>
	<key>AMApplicationVersion</key>
	<string>2.10</string>
	<key>AMDocumentVersion</key>
	<string>2</string>
	<key>actions</key>
	<array>
		<dict>
			<key>action</key>
			<dict>
				<key>AMAccepts</key>
				<dict>
					<key>Container</key>
					<string>List</string>
					<key>Optional</key>
					<true/>
					<key>Types</key>
					<array>
						<string>com.apple.cocoa.string</string>
					</array>
				</dict>
				<key>AMActionVersion</key>
				<string>2.0.3</string>
				<key>AMApplication</key>
				<array>
					<string>Automator</string>
				</array>
				<key>AMParameterProperties</key>
				<dict>
					<key>COMMAND_STRING</key>
					<dict/>
					<key>CheckedForUserDefaultShell</key>
					<dict/>
					<key>inputMethod</key>
					<dict/>
					<key>shell</key>
					<dict/>
					<key>source</key>
					<dict/>
				</dict>
				<key>AMProvides</key>
				<dict>
					<key>Container</key>
					<string>List</string>
					<key>Types</key>
					<array>
						<string>com.apple.cocoa.string</string>
					</array>
				</dict>
				<key>ActionBundlePath</key>
				<string>/System/Library/Automator/Run Shell Script.action</string>
				<key>ActionName</key>
				<string>Run Shell Script</string>
				<key>ActionParameters</key>
				<dict>
					<key>COMMAND_STRING</key>
					<string>PLACEHOLDER</string>
					<key>CheckedForUserDefaultShell</key>
					<true/>
					<key>inputMethod</key>
					<integer>1</integer>
					<key>shell</key>
					<string>/bin/zsh</string>
					<key>source</key>
					<string></string>
				</dict>
				<key>BundleIdentifier</key>
				<string>com.apple.RunShellScript</string>
				<key>CFBundleVersion</key>
				<string>2.0.3</string>
				<key>CanShowSelectedItemsWhenRun</key>
				<false/>
				<key>CanShowWhenRun</key>
				<true/>
				<key>Category</key>
				<array>
					<string>AMCategoryUtilities</string>
				</array>
				<key>Class Name</key>
				<string>RunShellScriptAction</string>
				<key>InputUUID</key>
				<string>D4E5F6A7-B8C9-0123-DEFA-234567890123</string>
				<key>Keywords</key>
				<array>
					<string>Shell</string>
					<string>Script</string>
					<string>Command</string>
					<string>Run</string>
					<string>Unix</string>
				</array>
				<key>OutputUUID</key>
				<string>E5F6A7B8-C9D0-1234-EFAB-345678901234</string>
				<key>UUID</key>
				<string>F6A7B8C9-D0E1-2345-FABC-456789012345</string>
				<key>UnlocalizedApplications</key>
				<array>
					<string>Automator</string>
				</array>
				<key>arguments</key>
				<dict>
					<key>0</key>
					<dict>
						<key>default value</key>
						<integer>0</integer>
						<key>name</key>
						<string>inputMethod</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>0</string>
					</dict>
					<key>1</key>
					<dict>
						<key>default value</key>
						<false/>
						<key>name</key>
						<string>CheckedForUserDefaultShell</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>1</string>
					</dict>
					<key>2</key>
					<dict>
						<key>default value</key>
						<string></string>
						<key>name</key>
						<string>source</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>2</string>
					</dict>
					<key>3</key>
					<dict>
						<key>default value</key>
						<string></string>
						<key>name</key>
						<string>COMMAND_STRING</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>3</string>
					</dict>
					<key>4</key>
					<dict>
						<key>default value</key>
						<string>/bin/sh</string>
						<key>name</key>
						<string>shell</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>4</string>
					</dict>
				</dict>
				<key>isViewVisible</key>
				<integer>1</integer>
				<key>location</key>
				<string>309.000000:630.000000</string>
				<key>nibPath</key>
				<string>/System/Library/Automator/Run Shell Script.action/Contents/Resources/Base.lproj/main.nib</string>
			</dict>
			<key>isViewVisible</key>
			<integer>1</integer>
		</dict>
	</array>
	<key>connectors</key>
	<dict/>
	<key>workflowMetaData</key>
	<dict>
		<key>applicationBundleID</key>
		<string>com.apple.finder</string>
		<key>applicationBundleIDsByPath</key>
		<dict>
			<key>/System/Library/CoreServices/Finder.app</key>
			<string>com.apple.finder</string>
		</dict>
		<key>applicationPath</key>
		<string>/System/Library/CoreServices/Finder.app</string>
		<key>applicationPaths</key>
		<array>
			<string>/System/Library/CoreServices/Finder.app</string>
		</array>
		<key>inputTypeIdentifier</key>
		<string>com.apple.Automator.fileSystemObject</string>
		<key>outputTypeIdentifier</key>
		<string>com.apple.Automator.nothing</string>
		<key>presentationMode</key>
		<integer>15</integer>
		<key>processesInput</key>
		<false/>
		<key>serviceApplicationBundleID</key>
		<string>com.apple.finder</string>
		<key>serviceApplicationPath</key>
		<string>/System/Library/CoreServices/Finder.app</string>
		<key>serviceInputTypeIdentifier</key>
		<string>com.apple.Automator.fileSystemObject</string>
		<key>serviceOutputTypeIdentifier</key>
		<string>com.apple.Automator.nothing</string>
		<key>serviceProcessesInput</key>
		<false/>
		<key>systemImageName</key>
		<string>NSActionTemplate</string>
		<key>useAutomaticInputType</key>
		<false/>
		<key>workflowTypeIdentifier</key>
		<string>com.apple.Automator.servicesMenu</string>
	</dict>
</dict>
</plist>
WFLOW_EOF

# Write the watermark removal shell script to a temp file
WM_SCRIPT_FILE=$(mktemp)
cat > "$WM_SCRIPT_FILE" << WM_SCRIPT_EOF
#!/bin/zsh

GEMINI_CMD="$WM_CMD"
success=0
errors=0
skipped=0

notify() {
    osascript -e "display notification \"\$1\" with title \"Remove Gemini Watermark\" sound name \"\$2\""
}

for input in "\$@"; do
    ext="\${input##*.}"
    ext="\${ext:l}"

    if [[ "\$ext" != "png" && "\$ext" != "jpg" && "\$ext" != "jpeg" && "\$ext" != "webp" ]]; then
        skipped=\$((skipped + 1))
        continue
    fi

    if [[ ! -f "\$input" ]]; then
        errors=\$((errors + 1))
        continue
    fi

    stem="\${input%.*}"
    output="\${stem}_cleaned.\${ext}"

    result=\$("\$GEMINI_CMD" remove "\$input" -o "\$output" 2>&1)
    if [[ \$? -eq 0 ]]; then
        success=\$((success + 1))
    else
        errors=\$((errors + 1))
        errmsg=\$(echo "\$result" | tail -1)
        notify "Failed: \${errmsg:0:80}" "Basso"
    fi
done

if [[ \$errors -gt 0 ]]; then
    notify "\$success cleaned, \$errors failed, \$skipped skipped" "Basso"
elif [[ \$success -gt 0 ]]; then
    notify "\$success image(s) cleaned" "Glass"
elif [[ \$skipped -gt 0 ]]; then
    notify "No supported images selected (\$skipped skipped)" "Basso"
else
    notify "No files provided" "Basso"
fi
WM_SCRIPT_EOF

# Inject the shell script into the plist using Python + temp file
python3 << PYEOF
import plistlib

with open("$WM_SCRIPT_FILE") as sf:
    script = sf.read()

wflow = "$WM_QA_DIR/document.wflow"
with open(wflow, "rb") as f:
    plist = plistlib.load(f)

plist["actions"][0]["action"]["ActionParameters"]["COMMAND_STRING"] = script

with open(wflow, "wb") as f:
    plistlib.dump(plist, f)
PYEOF
rm -f "$WM_SCRIPT_FILE"

# Write the Info.plist
cat > "$WM_QA_DIR/Info.plist" << 'PLIST_EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>NSServices</key>
	<array>
		<dict>
			<key>NSBackgroundColorName</key>
			<string>background</string>
			<key>NSIconName</key>
			<string>NSActionTemplate</string>
			<key>NSMenuItem</key>
			<dict>
				<key>default</key>
				<string>Remove Gemini Watermark</string>
			</dict>
			<key>NSMessage</key>
			<string>runWorkflowAsService</string>
			<key>NSRequiredContext</key>
			<dict>
				<key>NSApplicationIdentifier</key>
				<string>com.apple.finder</string>
			</dict>
			<key>NSSendFileTypes</key>
			<array>
				<string>public.image</string>
			</array>
		</dict>
	</array>
</dict>
</plist>
PLIST_EOF

echo "  Installed."

# --- Register Quick Actions ---
echo ""
echo "Registering Quick Actions with macOS..."
/System/Library/CoreServices/pbs -flush 2>/dev/null
/System/Library/CoreServices/pbs -update 2>/dev/null

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Quick Actions installed:"
echo "  - Spell Check Infographic  (right-click PNG/PDF in Finder)"
echo "  - Remove Gemini Watermark  (right-click images in Finder)"
echo ""
echo "If they don't appear in the right-click menu, restart Finder:"
echo "  killall Finder"
