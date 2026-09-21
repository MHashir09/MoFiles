import QtQuick
import Quickshell.Io

Item {
	id: root

	function readPrimarySelection(callback) {
		reader._callback = callback
		reader._data = ""
		reader.running = true
		timeoutTimer.start()
	}

	Process {
		id: reader

		property var _callback: null
		property string _data: ""

		running: false
		command: ["wl-paste", "--primary", "-n"]

		stdout: SplitParser {
			onRead: data => {
				if (reader._data.length > 0) reader._data += "\n"
				reader._data += data
			}
		}

		onExited: (code, status) => {
			timeoutTimer.stop()
			if (_callback) {
				var cb = _callback
				_callback = null
				cb(code === 0 ? _data : "")
			}
		}
	}

	Timer {
		id: timeoutTimer
		interval: 2000
		onTriggered: {
			var cb = reader._callback
			reader._callback = null
			reader.running = false
			if (cb) cb("")
		}
	}
}
