import QtQuick 2.0
import QtQuick.Layouts 1.1

Item {
	id: item

	property int activeItem : 0
	property int itemIndex  : 0

	property alias children : column.children

	property Component terminalItem : Component { TerminalItem { } }

	function onItemExecuted(index) {
		if ( index === (children.length - 1) ) {
			createItem();
		}
	}

	function createItem() {
		var instantiateTerminal = function() {
			var instance = terminalItem.createObject(column, {
				"index" : itemIndex,
				"width" : flickable.width
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
		if ( column.height >= flickable.height ) {
			var offset = children[index].y;

			if ( children[index].height > flickable.height ) {
				offset -= (flickable.height / 2);
			} else {
				offset += (children[index].height / 2)
				        - (flickable.height / 2);
			}

			var bound  = column.height
			           - flickable.height;

			if ( offset < 0 ) {
				flickable.contentY = 0;
			} else if ( offset >= bound ) {
				flickable.contentY = bound;
			} else {
				flickable.contentY = offset;
			}
		}
	}

	function selectItem(index) {
		children[activeItem].deselect();
		children[index     ].select();

		activeItem = typeof index === "number" ? index : parseInt(index);

		scrollTo(index);
	}

	function selectNext() {
		if ( activeItem < (children.length - 1) ) {
			selectItem(activeItem + 1);
		} else {
			mode.enterInsertMode();
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

	function get(index) {
		return children[index];
	}

	function iterate(func) {
		for ( var i = 0; i < children.length; i++ ) {
			func(children[i]);
		}
	}

	Flickable {
		id: flickable

		anchors.fill: parent

		boundsBehavior: Flickable.StopAtBounds
		contentHeight:  column.height
		contentWidth:   parent.width
		pixelAligned:   true

		Column {
			id: column

			anchors {
				left:  parent.left
				right: parent.right
			}

			spacing: 10

			onHeightChanged: scrollTo(activeItem)
		}
	}
}
