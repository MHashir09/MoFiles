import QtQuick
import Quickshell.Io

Item {
	id: root

	function translate(text, engine, callback) {
		var proc = procComponent.createObject(root, {
			_callback: callback,
		})
		proc.command = ["trans", "-no-auto", "-b", "-s", "ja", "-t", "en", "-e", engine, "--", text]
		proc.running = true
	}

	Component {
		id: procComponent

		Process {
			property var _callback: null
			property var _stdoutLines: []
			property string _stderrText: ""

			stdout: SplitParser {
				onRead: data => {
					_stdoutLines.push(data)
				}
			}

			stderr: SplitParser {
				onRead: data => {
					_stderrText += data
				}
			}

			onExited: (code, status) => {
				if (_callback) {
					if (code === 0) {
						_callback({ result: _stdoutLines.join("\n") })
					} else {
						_callback({ error: _stderrText })
					}
				}
				destroy()
			}
		}
	}
}
