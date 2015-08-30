import QtQuick 2.0
import QtQuick.Layouts 1.1

import "commands.js" as Commands

Item {
	id: item

	signal executed

	function focus(prefix) {
		visible      = true;
		command.text = prefix;
		command.forceActiveFocus();
	}

	function unfocus() {
		visible = false;
	}

	visible: false

	Layout.preferredHeight: container.height

	onVisibleChanged: container.reset()

	Rectangle {
		anchors {
			top:   parent.top
			left:  parent.left
			right: parent.right
		}

		height: container.height

		color: settings.command.background

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
					family:    settings.command.fontFamily
					pointSize: settings.command.fontSize
				}

				color:             settings.command.fontColor
				selectionColor:    settings.command.fontColor
				selectedTextColor: settings.command.background
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

			TextEdit {
				id: output

				Layout.fillWidth:       true
				Layout.preferredHeight: 0

				font {
					family:    settings.command.fontFamily
					pointSize: settings.command.fontSize
				}

				color:             settings.command.fontColor
				selectionColor:    settings.command.fontColor
				selectedTextColor: settings.command.background

				selectByMouse: true
				readOnly:      true

				textFormat: TextEdit.RichText
				wrapMode:   TextEdit.NoWrap

				function isInitial() {
					return length === 0;
				}

				function initialize() {
					text = '';
				}

				function log(msg) {
					if ( isInitial() ) {
						text = msg;
					} else {
						text += '\n' + msg;
					}
				}

				function error(msg) {
					text = '<i><font color="'
					     + settings.command.errorColor
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
