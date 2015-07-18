import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Item {
	id: item

	property int              index    : 0
	property EmbeddedTerminal terminal : null

	signal executed

	height: elementList.height

	function select() {
		if ( terminal === null ) {
			highlighter.select();
		} else {
			terminal.select();
		}
	}

	function deselect() {
		if ( terminal === null ) {
			highlighter.deselect();
		} else {
			terminal.deselect();
		}
	}

	function forceActiveFocus() {
		scope.forceActiveFocus();

		if ( terminal === null ) {
			scope.forceActiveFocus();
			highlighter.select();
			highlighter.focus();
		}
	}

	function unfocus() {
		if ( terminal === null ) {
			highlighter.unfocus();
		}
	}

	FocusScope {
		id: scope

		Column {
			id: elementList

			function createTerminal(program) {
				var terminalComponent   = Qt.createComponent("qrc:/EmbeddedTerminal.qml");
				var instantiateTerminal = function() {
					item.terminal = terminalComponent.createObject(elementList, {
						"columns"          : 90,
						"lines"            : 20,
						"program"          : program,
						"workingDirectory" : "$HOME",
						"focus"            : true
					});
				}

				if ( terminalComponent.status === Component.Ready ) {
					instantiateTerminal();
				} else {
					terminalComponent.statusChanged.connect(instantiateTerminal);
				}
			}

			RowLayout {
				width: item.width

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
						if ( item.terminal === null ) {
							readOnly = true;
							focus    = false;

							elementList.createTerminal(text);
							item.executed();
							highlighter.deselect();
						}
					}
				}

				Text {
					text: item.index
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
