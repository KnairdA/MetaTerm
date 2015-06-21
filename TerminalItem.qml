import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Item {
	id: terminalItem
	signal executed

	height: elementList.height

	function focus() {
		if ( command.readOnly ) {
			elementList.children[1].focus();
		} else {
			command.forceActiveFocus();
		}
	}

	Column {
		id: elementList

		function createTerminal(program) {
			var terminal = Qt.createComponent("EmbeddedTerminal.qml");
			var instantiateTerminal = function() {
				terminal.createObject(elementList, {
					"columns": 90,
					"lines": 20,
					"program": program,
					"workingDirectory": "$HOME"
				});
			}

			if ( terminal.status == Component.Ready ) {
				instantiateTerminal();
			} else {
				terminal.statusChanged.connect(instantiateTerminal);
			}
		}

		RowLayout {
			width: terminalItem.width

			Text {
				text: "> "
				font.pointSize: 18
				color: "white"
			}

			TextInput {
				id: command

				font.pointSize: 18
				color: "white"
				selectedTextColor: "#161616"
				selectionColor: "white"
				selectByMouse: true

				Layout.fillWidth: true

				onAccepted: {
					if ( !readOnly ) {
						readOnly = true;
						elementList.createTerminal(text);
						terminalItem.executed();
					}
				}
			}
		}
	}
}
