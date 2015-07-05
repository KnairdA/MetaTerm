import QtQuick 2.0;

Item {
	id: scrollbar
	width: (handleSize + 2)
	visible: (flickable.visibleArea.heightRatio < 1.0)

	anchors {
		top: flickable.top
		right: flickable.right
		bottom: flickable.bottom
	}

	property Flickable flickable
	property int       handleSize

	Item {
		id: bar

		anchors.fill: parent

		Rectangle {
			anchors.fill: parent
			color: "black"
			opacity: 0.5
		}

		MouseArea {
			id: control
			anchors.fill: parent

			drag {
				target: handle
				minimumY: 0
				maximumY: (bar.height - handle.height)
				axis: Drag.YAxis
			}

			onClicked: {
				flickable.contentY = (mouse.y / bar.height * (flickable.contentHeight - flickable.height));
			}
		}

		Item {
			id: handle;
			height: Math.max(20, (flickable.visibleArea.heightRatio * bar.height))

			anchors {
				left: parent.left
				right: parent.right
			}

			Rectangle {
				id: backHandle
				anchors {
					fill: parent
					margins: 1
				}

				color: (control.pressed ? "gray" : "white")
			}
		}
	}

	Binding {
		target: handle
		property: "y"
		value: (flickable.contentY * control.drag.maximumY / (flickable.contentHeight - flickable.height))
		when: (!control.drag.active)
	}

	Binding {
		target: flickable
		property: "contentY"
		value: (handle.y * (flickable.contentHeight - flickable.height) / control.drag.maximumY)
		when: (control.drag.active || control.pressed)
	}
}
