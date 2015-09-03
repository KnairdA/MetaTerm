import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Item {
	id: item

	property EmbeddedTerminal terminal : null
	property HistoryViewer    history  : null
	property int              index    : 0

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
			command.readOnly = false;
			highlighter.select();
			highlighter.focus();
		}
	}

	function unfocus() {
		if ( terminal === null ) {
			command.readOnly = true;
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
			terminal = null;
		} else if ( history !== null ) {
			history.destroy();
			history = null;
		}

		command.focus = true;
		mode.enterNormalMode();
		unfocus();
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
					if ( item.history !== null ) {
						item.history.destroy();
						item.history = null;
					}

					item.terminal = terminalComponent.createObject(elementList, {
						"settings"         : settings,
						"program"          : program,
						"workingDirectory" : "$HOME",
						"focus"            : true
					});
					item.terminal.onFinished.connect(function() {
						createHistoryViewer(item.terminal.history);
						item.reset();
						item.select();

						if ( item.index === ( terminalList.children.length - 2 ) ) {
							terminalList.selectNext();
							mode.enterInsertMode();
						}
					});
				}

				if ( terminalComponent.status === Component.Ready ) {
					instantiateTerminal();
				} else {
					terminalComponent.statusChanged.connect(instantiateTerminal);
				}
			}

			function createHistoryViewer(history) {
				var historyComponent   = Qt.createComponent("qrc:/HistoryViewer.qml");
				var instantiateHistory = function() {
					item.history = historyComponent.createObject(elementList, {
						"history" : history
					});
				}

				if ( historyComponent.status === Component.Ready ) {
					instantiateHistory();
				} else {
					historyComponent.statusChanged.connect(instantiateHistory);
				}
			}

			RowLayout {
				spacing: 0

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
						family:    settings.item.fontFamily
						pointSize: settings.item.fontSize
					}

					color:             settings.item.fontColor
					selectionColor:    settings.item.fontColor
					selectedTextColor: settings.window.background

					selectByMouse:    true
					focus:            true
					Layout.fillWidth: true

					onAccepted: {
						if ( !readOnly ) {
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
						family: settings.item.fontFamily
						pointSize: settings.item.fontSize / 1.5
					}
					color: settings.item.fontColor

					text: item.index
				}
			}
		}
	}
}
