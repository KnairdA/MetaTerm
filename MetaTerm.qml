import QtQuick 2.0
import QMLTermWidget 1.0
import QtQuick.Controls 1.2


Rectangle {
	id: root
	anchors.fill: parent

	color: "#161616"

	Component.onCompleted: terminalList.focusCurrent()

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

			function scrollTo(index) {
				if ( terminalList.height >= terminalListFlickable.height ) {
					var offset = children[index].y
					           + (children[index].height       / 2)
					           - (terminalListFlickable.height / 2);

					var bound  = terminalList.height
					           - terminalListFlickable.height;

					if ( offset < 0 ) {
						terminalListFlickable.contentY = 0;
					} else if ( offset >= bound ) {
						terminalListFlickable.contentY = bound;
					} else {
						terminalListFlickable.contentY = offset;
					}
				}
			}

			function selectItem(index) {
				children[activeItem].deselect();
				children[index     ].select();

				activeItem = index;

				scrollTo(index);
			}

			function selectNext() {
				if ( activeItem < (children.length - 1) ) {
					selectItem(activeItem + 1);
				} else {
					insertTerminalAction.trigger();
				}
			}

			function selectPrev() {
				if ( activeItem > 0 ) {
					selectItem(activeItem - 1);
				}
			}

			function focusCurrent() {
				children[activeItem].forceActiveFocus();
			}

			function unfocusCurrent() {
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
			lastTerminalAction.enabled   = false;
			firstTerminalAction.enabled  = false;

			terminalList.focusCurrent();
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
			lastTerminalAction.enabled   = true;
			firstTerminalAction.enabled  = true;

			root.forceActiveFocus();
			terminalList.unfocusCurrent();
		}
	}

	Action {
		id: nextTerminalAction
		shortcut: "j"
		enabled: false
		onTriggered: terminalList.selectNext()
	}

	Action {
		id: prevTerminalAction
		shortcut: "k"
		enabled: false
		onTriggered: terminalList.selectPrev()
	}

	Action {
		id: lastTerminalAction
		shortcut: "Shift+G"
		enabled: false
		onTriggered: terminalList.selectItem(terminalList.children.length - 1)
	}

	Action {
		id: firstTerminalAction
		shortcut: "g"
		enabled: false
		onTriggered: terminalList.selectItem(0)
	}

	ScrollBar {
		flickable: terminalListFlickable
		handleSize: 10
	}
}
