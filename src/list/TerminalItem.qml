import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import Qt.labs.settings 1.0

Item {
	id: item

	property int              index    : 0
	property EmbeddedTerminal terminal : null

	signal executed (int index)

	property Settings settings : Settings {
		category: "item"

		property int    fontSize   : 18
		property string fontFamily : "Monospace"
		property string fontColor  : "white"
	}

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
			} else {
				terminal.displayOverlay();
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

				Highlighter {
					id: highlighter

					width: 10
					height: command.height
				}

				TextInput {
					id: command

					font {
						family:    settings.fontFamily
						pointSize: settings.fontSize
					}

					color:             settings.fontColor
					selectionColor:    settings.fontColor
					selectedTextColor: "#161616"

					selectByMouse:    true
					focus:            true
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
					font {
						family: settings.fontFamily
						pointSize: settings.fontSize / 1.5
					}
					color: settings.fontColor

					text: item.index
				}
			}
		}
	}
}
