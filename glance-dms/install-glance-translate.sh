#!/bin/zsh
# Install/overwrite Glance Translate plugin with the ja→en fixed version
# Usage: ./install-glance-translate.sh [target-dir]
# Default: ~/.config/DankMaterialShell/plugins/glance

TARGET="${1:-$HOME/.config/DankMaterialShell/plugins/glance}"

if [ ! -d "$TARGET" ]; then
	echo "Error: $TARGET does not exist. Install the plugin from DMS registry first."
	exit 1
fi

SCRIPT_DIR="${0:A:h}"
cp -v "$SCRIPT_DIR/glance-translate-backup/plugin.json" "$TARGET/"
cp -v "$SCRIPT_DIR/glance-translate-backup/TranslationEngine.qml" "$TARGET/"
cp -v "$SCRIPT_DIR/glance-translate-backup/GlanceWidget.qml" "$TARGET/"
cp -v "$SCRIPT_DIR/glance-translate-backup/GlanceSettings.qml" "$TARGET/"
cp -v "$SCRIPT_DIR/glance-translate-backup/SelectionReader.qml" "$TARGET/"

echo "Done. Run 'systemctl --user restart dms' to reload."
