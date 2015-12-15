import QtQuick 2.0

Item {
	function select()   { bar.opacity = 1                                 }
	function deselect() { bar.opacity = 0                                 }
	function focus()    { bar.color   = settings.highlighter.focusColor   }
	function unfocus()  { bar.color   = settings.highlighter.defaultColor }

	Rectangle {
		id: bar

		anchors.fill: parent

		opacity: 0
		color: settings.highlighter.defaultColor

		Behavior on opacity {
			NumberAnimation {
				duration: 300
				easing.type: Easing.OutCubic
			}
		}
	}
}
