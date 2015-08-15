import QtQuick 2.0
import QtQuick.Layouts 1.1
import Qt.labs.settings 1.0

import "commands.js" as Commands

Item {
	id: item

	signal executed

	visible: false

	Layout.preferredHeight: container.height

	property Settings settings : Settings {
		category: "command"

		property string background : "black"
		property int    fontSize   : 12
		property string fontFamily : "Monospace"
		property string fontColor  : "white"
		property string errorColor : "red"
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
				command.initialize();
				output.initialize();
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

				function initialize() {
					text = '';
				}

				onAccepted: {
					output.initialize();

					const prefix = String(text).charAt(0);
					const cmd    = String(text).substring(1, String(text).length);

					switch ( prefix ) {
						case ':': {
							Commands.execute(output, cmd);
							break;
						}
						default: {
							output.error('"' + prefix + '"' + ' is not a command prefix.');
						}
					}

					if ( output.isInitial() ) {
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

				function isInitial() {
					return text === '';
				}

				function initialize() {
					text = '';
				}

				function log(msg) {
					if ( isInitial() ) {
						text = msg;
					} else {
						text += '<br/>' + msg;
					}
				}

				function error(msg) {
					text = '<i><font color="'
					     + settings.errorColor
					     + '">'
					     + msg
					     + '</font></i>';
				}

				onTextChanged: {
					if ( isInitial() ) {
						Layout.preferredHeight = 0;
					} else {
						Layout.preferredHeight = contentHeight;
					}
				}
			}
		}
	}
}
