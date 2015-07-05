import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Item {
	id: terminalItem

	property int index : 0

	signal executed

	height: elementList.height

	function select() {
		if ( command.readOnly ) {
			elementList.children[1].select();
		} else {
			highlighter.select();
		}
	}

	function deselect() {
		if ( command.readOnly ) {
			elementList.children[1].deselect();
		} else {
			highlighter.deselect();
		}
	}

	function forceActiveFocus() {
		if ( command.readOnly ) {
			scope.forceActiveFocus();
		} else {
			scope.forceActiveFocus();
			highlighter.select();
			highlighter.focus();
		}
	}

	function unfocus() {
		if ( !command.readOnly ) {
			highlighter.unfocus();
		}
	}

	FocusScope {
		id: scope

		Column {
			id: elementList

			function createTerminal(program) {
				var terminal = Qt.createComponent("qrc:/EmbeddedTerminal.qml");
				var instantiateTerminal = function() {
					terminal.createObject(elementList, {
						"columns": 90,
						"lines": 20,
						"program": program,
						"workingDirectory": "$HOME",
						"focus": true
					});
				}

				if ( terminal.status === Component.Ready ) {
					instantiateTerminal();
				} else {
					terminal.statusChanged.connect(instantiateTerminal);
				}
			}

			RowLayout {
				width: terminalItem.width

				Rectangle {
					id: highlighter

					width: 10
					height: command.height
					opacity: 0

					color: "#909636"

					Behavior on opacity {
						NumberAnimation {
							duration: 300
							easing.type: Easing.OutCubic
						}
					}

					function select()   { opacity = 1         }
					function deselect() { opacity = 0         }
					function focus()    { color   = "#352F6A" }
					function unfocus()  { color   = "#909636" }
				}

				TextInput {
					id: command

					font {
						family: "Monospace"
						pointSize: 18
					}
					color: "white"
					selectionColor: "white"
					selectedTextColor: "#161616"
					selectByMouse: true
					focus: true

					Layout.fillWidth: true

					onAccepted: {
						if ( !readOnly ) {
							readOnly = true;
							focus    = false;
							elementList.createTerminal(text);
							terminalItem.executed();
							highlighter.deselect();
						}
					}
				}

				Text {
					text: terminalItem.index
					font {
						family: "Monospace"
						pointSize: 12
					}
					color: "white"
				}
			}
		}
	}
}
