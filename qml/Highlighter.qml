import QtQuick 2.0

Item {
	function select()   { bar.opacity = 1         }
	function deselect() { bar.opacity = 0         }
	function focus()    { bar.color   = "#352F6A" }
	function unfocus()  { bar.color   = "#909636" }

	Rectangle {
		id: bar

		anchors.fill: parent

		opacity: 0
		color: "#909636"

		Behavior on opacity {
			NumberAnimation {
				duration: 300
				easing.type: Easing.OutCubic
			}
		}
	}
}
