import QtQuick 2.0
import QMLTermWidget 1.0
import QtQuick.Layouts 1.1

Item {
	id: item

	property QMLTermSession session : null

	function update() {
		var shellPID = session.getShellPID();

		pid.text              = shellPID;
		workingDirectory.text = cwd.currentOfPID(shellPID);
	}

	height: wrap.height

	RowLayout {
		id: wrap

		anchors.right: parent.right
		anchors.left:  parent.left

		Layout.alignment: Qt.AlignRight

		spacing: 5

		Rectangle {
			Layout.fillWidth: true

			anchors.fill: wrap

			color: settings.terminal.statusBackground
		}

		Text {
			id: pid

			Layout.rightMargin:  4
			Layout.bottomMargin: 2

			font {
				family:    settings.terminal.fontFamily
				pointSize: settings.terminal.fontSize
			}
			color: settings.terminal.statusFontColor
		}

		Text {
			Layout.rightMargin:  4
			Layout.bottomMargin: 2

			font {
				family:    settings.terminal.fontFamily
				pointSize: settings.terminal.fontSize
			}
			color: settings.terminal.statusFontColor

			text: "@"
		}

		Text {
			id: workingDirectory

			Layout.rightMargin:  4
			Layout.bottomMargin: 2

			font {
				family:    settings.terminal.fontFamily
				pointSize: settings.terminal.fontSize
			}
			color: settings.terminal.statusFontColor
		}
	}
}
