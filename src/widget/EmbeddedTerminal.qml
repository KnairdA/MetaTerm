import QtQuick 2.0
import QMLTermWidget 1.0
import QtQuick.Layouts 1.1

Item {
	id: item

	property string          program
	property string          workingDirectory

	property int   lines    : settings.terminal.initialLines

	height: terminal.height
	width:  parent.width - settings.terminal.frameWidth

	function select()         { highlighter.select()     }
	function deselect()       { highlighter.deselect()   }
	function displayOverlay() { overlay.displayBriefly() }

	RowLayout {
		id: container

		anchors {
			left:  parent.left
			right: parent.right
		}

		spacing: 0

		Highlighter {
			id: highlighter

			width: settings.terminal.frameWidth
			Layout.fillHeight: true
		}

		QMLTermWidget {
			id: terminal

			font {
				family:    settings.terminal.fontFamily
				pointSize: settings.terminal.fontSize
			}

			Layout.fillWidth:       true
			Layout.preferredHeight: fontMetrics.height * item.lines

			colorScheme: settings.terminal.colorScheme

			session: QMLTermSession {
				initialWorkingDirectory: item.workingDirectory

				shellProgram: {
					return (item.program).split(" ")[0];
				}

				shellProgramArgs: {
					const elements = (item.program).split(" ");
					elements.shift();

					return elements;
				}
			}

			Component.onCompleted: {
				forceActiveFocus();
				highlighter.select();
				session.startShellProgram();
				overlay.enabled = true;
			}

			onTermGetFocus:  highlighter.focus()
			onTermLostFocus: highlighter.unfocus()
			onHeightChanged: overlay.displayBriefly();
			onWidthChanged:  overlay.displayBriefly();

			Rectangle {
				id: overlay

				property bool enabled : false

				function displayBriefly() {
					if ( enabled ) { animation.restart() }
				}

				anchors.fill: parent
				opacity: 0
				color: settings.terminal.overlayBackground

				SequentialAnimation {
					id: animation

					ScriptAction {
						script: overlay.opacity = 0.8
					}

					PauseAnimation {
						duration: 500
					}

					NumberAnimation {
						target:   overlay
						property: "opacity"

						easing.type: Easing.InSine
						duration: 300
						from:     0.8
						to:       0
					}
				}

				Text {
					anchors {
						horizontalCenter: overlay.horizontalCenter
						verticalCenter:   overlay.verticalCenter
					}

					font {
						family:    settings.terminal.fontFamily
						pointSize: settings.terminal.fontSize * 2
					}
					color: settings.terminal.overlayFontColor

					text: {
						return item.lines
						       + 'x'
						       + Math.floor(terminal.width / terminal.fontMetrics.width);
					}
				}
			}

			MouseArea {
				anchors.fill: parent
				acceptedButtons: Qt.NoButton
				onWheel: { }
			}
		}
	}
}
