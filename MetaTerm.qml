import QtQuick 2.0
import QMLTermWidget 1.0
import QtQuick.Controls 1.2

Rectangle {
	anchors.fill: parent

	color: "#161616"

	Flickable {
		id: terminalListFlickable
		boundsBehavior: Flickable.StopAtBounds
		width: 600
		anchors.fill: parent

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
					children[++activeItem].focus();
				}
			}

			function prevItem() {
				if ( activeItem > 0 ) {
					children[--activeItem].focus();
				}
			}

			TerminalItem {
				width: terminalListFlickable.width
				onExecuted: terminalList.createItem()
			}
		}

		contentHeight: terminalList.height
		contentWidth:  terminalList.width
	}

	Action {
		id: nextTerminalAction
		shortcut: "j"
		onTriggered: terminalList.nextItem()
	}

	Action {
		id: prevTerminalAction
		shortcut: "k"
		onTriggered: terminalList.prevItem()
	}

	ScrollBar {
		flickable: terminalListFlickable
		handleSize: 10
	}
}
