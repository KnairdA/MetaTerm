import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Item {
	id: item

	property int              index    : 0
	property EmbeddedTerminal terminal : null

	signal executed (int index)

	anchors {
		left:  parent.left
		right: parent.right
	}

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

	function heighten() {
		if ( terminal !== null ) {
			terminal.lines += 1;
		}
	}

	function shorten() {
		if ( terminal !== null ) {
			if ( terminal.lines > 10 ) {
				terminal.lines -= 1;
			}
		}
	}

	function reset() {
		if ( terminal !== null ) {
			terminal.destroy();

			terminal         = null;
			command.readOnly = false;
			command.focus    = true;

			unfocus();
			select();
		}
	}

	FocusScope {
		id: scope

		anchors {
			left:  parent.left
			right: parent.right
		}

		Column {
			id: elementList

			anchors {
				left:  parent.left
				right: parent.right
			}

			function createTerminal(program) {
				var terminalComponent   = Qt.createComponent("qrc:/EmbeddedTerminal.qml");
				var instantiateTerminal = function() {
					item.terminal = terminalComponent.createObject(elementList, {
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
				anchors {
					left:  parent.left
					right: parent.right
				}

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
							item.executed(item.index);
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
