import QtQuick 2.0
import QMLTermWidget 1.0
import QtQuick.Controls 1.2


Rectangle {
	id: root
	anchors.fill: parent

	color: "#161616"

	Component.onCompleted: terminalList.focusItem()

	Flickable {
		id: terminalListFlickable
		anchors.fill: parent

		boundsBehavior: Flickable.StopAtBounds
		contentHeight:  terminalList.height
		contentWidth:   terminalList.width

		Column {
			id: terminalList
			spacing: 10

			property int activeItem : 0

			function createItem() {
				var terminalItem = Qt.createComponent("TerminalItem.qml");
				var instantiateTerminal = function() {
					var instance = terminalItem.createObject(terminalList, {
						"width": terminalListFlickable.width
					});
					instance.onExecuted.connect(createItem);
				}

				if ( terminalItem.status == Component.Ready ) {
					instantiateTerminal();
				} else {
					terminalItem.statusChanged.connect(instantiateTerminal);
				}
			}

			function nextItem() {
				if ( activeItem < (children.length - 1) ) {
					children[  activeItem].deselect();
					children[++activeItem].select();
				} else {
					insertTerminalAction.trigger();
				}
			}

			function prevItem() {
				if ( activeItem > 0 ) {
					children[  activeItem].deselect();
					children[--activeItem].select();
				}
			}

			function focusItem() {
				children[activeItem].forceActiveFocus();
			}

			function unfocusItem() {
				children[activeItem].unfocus();
			}

			TerminalItem {
				width: terminalListFlickable.width
				onExecuted: terminalList.createItem()
			}
		}
	}

	Action {
		id: insertTerminalAction
		shortcut: "i"
		enabled: false
		onTriggered: {
			escapeTerminalAction.enabled = true;
			insertTerminalAction.enabled = false;
			nextTerminalAction.enabled   = false;
			prevTerminalAction.enabled   = false;

			terminalList.focusItem();
		}
	}

	Action {
		id: escapeTerminalAction
		shortcut: "Shift+ESC"
		onTriggered: {
			escapeTerminalAction.enabled = false;
			insertTerminalAction.enabled = true;
			nextTerminalAction.enabled   = true;
			prevTerminalAction.enabled   = true;

			root.forceActiveFocus();
			terminalList.unfocusItem();
		}
	}

	Action {
		id: nextTerminalAction
		shortcut: "j"
		enabled: false
		onTriggered: terminalList.nextItem()
	}

	Action {
		id: prevTerminalAction
		shortcut: "k"
		enabled: false
		onTriggered: terminalList.prevItem()
	}

	ScrollBar {
		flickable: terminalListFlickable
		handleSize: 10
	}
}
