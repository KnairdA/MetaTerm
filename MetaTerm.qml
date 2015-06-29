import QtQuick 2.0
import QMLTermWidget 1.0
import QtQuick.Controls 1.2


Rectangle {
	id: root
	anchors.fill: parent

	color: "#161616"

	property string uiMode : "insert"

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
					children[  activeItem].deselect();
					children[++activeItem].select();
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

		contentHeight: terminalList.height
		contentWidth:  terminalList.width
	}

	Action {
		id: insertTerminalAction
		shortcut: "i"
		onTriggered: {
			switch ( uiMode ) {
				case "normal": {
					uiMode = "insert";
					terminalList.focusItem();
					break;
				}
				default: {
					break;
				}
			}

			console.log(uiMode);
		}
	}

	Action {
		id: escapeTerminalAction
		shortcut: "Shift+ESC"
		onTriggered: {
			switch ( uiMode ) {
				case "insert": {
					uiMode = "normal";
					root.forceActiveFocus();
					terminalList.unfocusItem();
					break;
				}
				default: {
					break;
				}
			}

			console.log(uiMode);
		}
	}

	Action {
		id: nextTerminalAction
		shortcut: "j"
		onTriggered: {
			switch ( uiMode ) {
				case "normal": {
					terminalList.nextItem();
					break;
				}
				default: {
					break;
				}
			}
		}
	}

	Action {
		id: prevTerminalAction
		shortcut: "k"
		onTriggered: {
			switch ( uiMode ) {
				case "normal": {
					terminalList.prevItem();
					break;
				}
				default: {
					break;
				}
			}
		}
	}

	ScrollBar {
		flickable: terminalListFlickable
		handleSize: 10
	}

	Component.onCompleted: terminalList.focusItem()
}
