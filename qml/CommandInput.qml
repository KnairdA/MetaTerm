import QtQuick 2.0
import QtQuick.Layouts 1.1
import Qt.labs.settings 1.0

import "commands.js" as Commands

Item {
	id: item

	signal executed

	visible: false

	Layout.preferredHeight: container.height

	Settings {
		id: settings
		category: "command"

		property color  background : "black"
		property int    fontSize   : 12
		property string fontFamily : "Monospace"
		property color  fontColor  : "white"
	}

	onVisibleChanged: container.reset()

	function focus(prefix) {
		visible      = true;
		command.text = prefix;
		command.forceActiveFocus();
	}

	function unfocus() {
		visible = false;
	}

	Rectangle {
		anchors {
			top:   parent.top
			left:  parent.left
			right: parent.right
		}

		height: container.height

		color: settings.background

		ColumnLayout {
			id: container

			function reset() {
				command.text = '';
				output.text  = '';
			}

			TextInput {
				id: command

				Layout.fillWidth: true

				font {
					family:    settings.fontFamily
					pointSize: settings.fontSize
				}

				color:             settings.fontColor
				selectionColor:    settings.fontColor
				selectedTextColor: settings.background
				selectByMouse:     true

				onAccepted: {
					const prefix = String(text).charAt(0);
					const cmd    = String(text).substring(1, String(text).length);

					switch ( prefix ) {
						case ':': {
							Commands.execute(output, cmd);
							break;
						}
						default: {
							output.log('"' + prefix + '"' + " is not a command prefix.");
						}
					}

					if ( output.text === '' ) {
						item.executed();
					}
				}
			}

			Text {
				id: output

				Layout.fillWidth:       true
				Layout.preferredHeight: 0

				font {
					family:    settings.fontFamily
					pointSize: settings.fontSize
				}

				color: settings.fontColor

				function log(msg) {
					text = msg;
				}

				onTextChanged: {
					if ( text === '' ) {
						Layout.preferredHeight = 0;
					} else {
						Layout.preferredHeight = contentHeight;
					}
				}
			}
		}
	}
}
