import QtQuick 2.0
import QtQuick.Layouts 1.1
import Qt.labs.settings 1.0

Item {
	id: item

	visible: false

	Settings {
		id: settings
		category: "command"

		property color  background : "black"
		property int    fontSize   : 12
		property string fontFamily : "Monospace"
		property color  fontColor  : "white"
	}

	function focus() {
		visible = true;
		command.forceActiveFocus();
	}

	function unfocus() {
		visible = false;
	}

	Rectangle {
		anchors.fill: parent
		color: settings.background

		TextInput {
			id: command

			font {
				family:    settings.fontFamily
				pointSize: settings.fontSize
			}

			color:             settings.fontColor
			selectionColor:    settings.fontColor
			selectedTextColor: settings.background
			text: ":"

			selectByMouse:    true

			onAccepted: {
				const prefix = String(text).charAt(0);
				const cmd    = String(text).substring(1, String(text).length);

				switch ( prefix ) {
					case ':': {
						eval(cmd);
						text = ':';
						break;
					}
					default: { }
				}
			}
		}
	}
}
