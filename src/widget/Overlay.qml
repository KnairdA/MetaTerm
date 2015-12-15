import QtQuick 2.0

Item {
	id: item

	property bool enabled : false

	property alias text : content.text

	function displayBriefly() {
		if ( enabled ) {
			animation.restart()
		}
	}

	Rectangle {
		id: background

		anchors.fill: parent

		opacity: 0
		color: settings.terminal.overlayBackground

		SequentialAnimation {
			id: animation

			ScriptAction {
				script: background.opacity = 0.8
			}

			PauseAnimation {
				duration: 500
			}

			NumberAnimation {
				target:   background
				property: "opacity"

				easing.type: Easing.InSine
				duration: 300
				from:     0.8
				to:       0
			}
		}

		Text {
			id: content

			anchors {
				horizontalCenter: background.horizontalCenter
				verticalCenter:   background.verticalCenter
			}

			font {
				family:    settings.terminal.fontFamily
				pointSize: settings.terminal.fontSize * 2
			}
			color: settings.terminal.overlayFontColor
		}
	}
}
