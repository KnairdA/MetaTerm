import QtQuick 2.0
import Qt.labs.settings 1.0

Item {
	property Settings settings : Settings {
		category: "highlighter"

		property string defaultColor : "#909636"
		property string focusColor   : "#352F6A"
	}

	function select()   { bar.opacity = 1                     }
	function deselect() { bar.opacity = 0                     }
	function focus()    { bar.color   = settings.focusColor   }
	function unfocus()  { bar.color   = settings.defaultColor }

	Rectangle {
		id: bar

		anchors.fill: parent

		opacity: 0
		color: settings.defaultColor

		Behavior on opacity {
			NumberAnimation {
				duration: 300
				easing.type: Easing.OutCubic
			}
		}
	}
}
