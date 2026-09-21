import QtQuick
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
	id: root

	layerNamespacePlugin: "glance-translate"
	popoutWidth: 640
	popoutHeight: 360

	Component.onCompleted: {
		depCheck.running = true
	}

	Process {
		id: depCheck
		command: ["which", "trans"]
		onExited: function(code) {
			if (code !== 0) {
				ToastService.showError(
					"Glance: translate-shell not installed",
					"Install with: sudo apt install translate-shell"
				)
			}
		}
	}

	horizontalBarPill: Component {
		DankIcon {
			name: "translate"
			color: Theme.primary
		}
	}
	verticalBarPill: Component {
		DankIcon {
			name: "translate"
			color: Theme.primary
			anchors.horizontalCenter: parent.horizontalCenter
		}
	}

	popoutContent: Component {
		PopoutComponent {
			id: popout

			headerText: ""
			showCloseButton: true

			property bool translating: false
			property string resultText: ""
			property string errorText: ""
			property bool _settingInput: false
			property string engine: pluginData.engine || "google"

			SelectionReader { id: selectionReader }
			TranslationEngine { id: translationEngine }

			function doTranslate(text) {
				if (!text || text.length === 0) return
				popout.translating = true
				popout.errorText = ""
				popout.resultText = ""
				translationEngine.translate(text, popout.engine, function(res) {
					popout.translating = false
					if (res.error) {
						popout.errorText = res.error
					} else {
						popout.resultText = res.result
					}
				})
			}

			Timer {
				id: debounceTimer
				interval: 500
				onTriggered: {
					var t = inputArea.text.trim()
					if (t.length > 0) popout.doTranslate(t)
				}
			}

			Item {
				width: parent.width
				implicitHeight: root.popoutHeight - popout.headerHeight - popout.detailsHeight

				Row {
					anchors.fill: parent
					anchors.margins: Theme.spacingM
					spacing: Theme.spacingM

					// === Left column: Source text ===
					Column {
						width: parent.width * 0.48
						height: parent.height
						spacing: Theme.spacingXS

						// Header row
						Item {
							width: parent.width
							height: 20

							StyledText {
								anchors.left: parent.left
								anchors.verticalCenter: parent.verticalCenter
								text: "Source"
								color: Theme.primary
								font.pixelSize: Theme.fontSizeSmall
								font.weight: Font.DemiBold
							}

							DankIcon {
								anchors.right: parent.right
								anchors.verticalCenter: parent.verticalCenter
								name: "content_copy"
								size: 14
								color: Theme.onSurfaceVariant
								opacity: copySrcArea.containsMouse ? 1.0 : 0.7

								MouseArea {
									id: copySrcArea
									anchors.fill: parent
									hoverEnabled: true
									cursorShape: Qt.PointingHandCursor
									onClicked: Quickshell.execDetached(["wl-copy", inputArea.text])
								}
							}
						}

						// Input area
						StyledRect {
							width: parent.width
							height: parent.height - 24
							radius: Theme.cornerRadius
							color: Theme.surfaceContainerHigh
							border.width: 1
							border.color: Theme.outlineVariant

							Flickable {
								anchors.fill: parent
								anchors.margins: Theme.spacingS
								clip: true
								contentHeight: inputArea.implicitHeight
								contentWidth: width

								TextEdit {
									id: inputArea
									width: parent.width
									wrapMode: TextEdit.Wrap
									color: Theme.surfaceText
									font.pixelSize: Theme.fontSizeMedium
									selectByMouse: true
									selectedTextColor: Theme.onPrimary
									selectionColor: Theme.primary
									onTextChanged: if (!popout._settingInput) debounceTimer.restart()
								}
							}
						}
					}

					// === Divider ===
					Rectangle {
						width: 1
						height: parent.height
						color: Theme.outlineVariant
					}

					// === Right column: Translation ===
					Column {
						width: parent.width * 0.48
						height: parent.height
						spacing: Theme.spacingXS

						// Header row
						Item {
							width: parent.width
							height: 20

							StyledText {
								anchors.left: parent.left
								anchors.verticalCenter: parent.verticalCenter
								text: "Translation"
								color: Theme.primary
								font.pixelSize: Theme.fontSizeSmall
								font.weight: Font.DemiBold
							}

							DankIcon {
								anchors.right: parent.right
								anchors.verticalCenter: parent.verticalCenter
								name: "content_copy"
								size: 14
								color: Theme.onSurfaceVariant
								visible: popout.resultText.length > 0
								opacity: visible ? (copyResultArea.containsMouse ? 1.0 : 0.7) : 0

								MouseArea {
									id: copyResultArea
									anchors.fill: parent
									hoverEnabled: true
									cursorShape: Qt.PointingHandCursor
									onClicked: Quickshell.execDetached(["wl-copy", popout.resultText])
								}
							}
						}

						// Result area
						StyledRect {
							width: parent.width
							height: parent.height - 24
							radius: Theme.cornerRadius
							color: Theme.surfaceContainerHigh
							border.width: 1
							border.color: Theme.outlineVariant

							// Loading
							StyledText {
								anchors.centerIn: parent
								visible: popout.translating
								text: "Translating..."
								color: Theme.onSurfaceVariant
								font.pixelSize: Theme.fontSizeLarge
								SequentialAnimation on opacity {
									running: popout.translating
									loops: Animation.Infinite
									NumberAnimation { from: 1.0; to: 0.3; duration: 800 }
									NumberAnimation { from: 0.3; to: 1.0; duration: 800 }
								}
							}

							// Error
							Flickable {
								anchors.fill: parent
								anchors.margins: Theme.spacingS
								clip: true
								contentHeight: errorLabel.implicitHeight
								contentWidth: width
								visible: !popout.translating && popout.errorText.length > 0

								StyledText {
									id: errorLabel
									text: popout.errorText
									color: Theme.error
									wrapMode: Text.Wrap
									width: parent.width
									font.pixelSize: Theme.fontSizeMedium
								}
							}

							// Result
							Flickable {
								anchors.fill: parent
								anchors.margins: Theme.spacingS
								clip: true
								contentHeight: resultLabel.implicitHeight
								contentWidth: width
								visible: !popout.translating && popout.resultText.length > 0

								StyledText {
									id: resultLabel
									text: popout.resultText
									color: Theme.surfaceText
									wrapMode: Text.Wrap
									width: parent.width
									font.pixelSize: Theme.fontSizeMedium
								}
							}
						}
					}
				}
			}

			onVisibleChanged: if (visible) {
				popout.translating = false
				popout.resultText = ""
				popout.errorText = ""
				popout._settingInput = true
				inputArea.text = ""
				popout._settingInput = false
				selectionReader.readPrimarySelection(function(text) {
					if (!popout.visible) return
					var trimmed = text.trim()
					if (trimmed.length > 0) {
						popout._settingInput = true
						inputArea.text = trimmed
						popout._settingInput = false
						popout.doTranslate(trimmed)
					}
				})
			}
		}
	}
}
