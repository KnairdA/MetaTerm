import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 1.2
import Qt.labs.settings 1.0

ApplicationWindow {
	id: root

	visible: true
	color: "#161616"

	Component.onCompleted: {
		terminalList.createItem();
		terminalList.focusCurrent();
	}

	Settings {
		category: "window"

		property alias color : root.color
	}

	Flickable {
		id: terminalListFlickable

		anchors.fill: parent

		boundsBehavior: Flickable.StopAtBounds
		contentHeight:  terminalList.height
		contentWidth:   parent.width
		pixelAligned:   true

		Column {
			id: terminalList

			property int activeItem : 0
			property int itemIndex  : 0

			anchors {
				left:  parent.left
				right: parent.right
			}

			spacing: 10

			onHeightChanged: scrollTo(activeItem)

			function onItemExecuted(index) {
				if ( index === (children.length - 1) ) {
					createItem();
				}
			}

			function createItem() {
				var terminalItem = Qt.createComponent("qrc:/TerminalItem.qml");
				var instantiateTerminal = function() {
					var instance = terminalItem.createObject(terminalList, {
						"index": itemIndex,
						"width": terminalListFlickable.width
					});
					instance.onExecuted.connect(onItemExecuted);

					++itemIndex;
				}

				if ( terminalItem.status === Component.Ready ) {
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
					state.enterInsertMode();
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

			function getCurrent() {
				return children[activeItem];
			}
        }
	}

	StateHandler {
		id: state

		terminalList: terminalList
	}
}
