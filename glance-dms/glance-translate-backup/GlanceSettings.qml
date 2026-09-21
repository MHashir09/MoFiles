import QtQuick
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginSettings {
	pluginId: "glance"

	StringSetting {
		key: "engine"
		label: "Translation Engine"
		description: "translate-shell engine name"
		defaultValue: "google"
		placeholder: "google, deepl, bing, yandex, apertium"
	}

	// Hotkey hint
	Item {
		width: parent.width
		height: hotkeyHint.implicitHeight + Theme.spacingM * 2

		StyledText {
			id: hotkeyHint
			anchors.fill: parent
			anchors.margins: Theme.spacingM
			wrapMode: Text.Wrap
			text: "Keyboard shortcut: add to your niri config:\nbinds { Mod+T { spawn \"dms\" \"ipc\" \"call\" \"widget\" \"toggle\" \"glance\"; } }"
			color: Theme.surfaceText
			font.pixelSize: Theme.fontSizeSmall
		}
	}
}
