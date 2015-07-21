import QtQuick 2.0
import QMLTermWidget 1.0
import QtQuick.Layouts 1.1

Item {
	id: item

	property string program
	property string workingDirectory
	property int    lines
	property int    frameWidth : 10

	height: terminal.height
	width:  parent.width - frameWidth

	function select()   { highlighter.select()   }
	function deselect() { highlighter.deselect() }

	RowLayout {
		id: container

		anchors {
			left:  parent.left
			right: parent.right
		}

		spacing: 0

		Rectangle {
			id: highlighter

			width: item.frameWidth
			Layout.fillHeight: true

			color: "#909636"

			Behavior on opacity {
				NumberAnimation {
					duration: 300
					easing.type: Easing.OutCubic
				}
			}

			function select()   { opacity = 1         }
			function deselect() { opacity = 0         }
			function focus()    { color   = "#352F6A" }
			function unfocus()  { color   = "#909636" }
		}

		QMLTermWidget {
			id: terminal

			font.family: "Monospace"
			font.pointSize: 8

			Layout.fillWidth: true
			Layout.preferredHeight: fontMetrics.height * item.lines

			colorScheme: "cool-retro-term"

			session: QMLTermSession {
				initialWorkingDirectory: item.workingDirectory

				shellProgram: {
					return (item.program).split(" ")[0];
				}

				shellProgramArgs: {
					var elements = (item.program).split(" ");
					elements.shift();

					return elements;
				}
			}

			onTermGetFocus: highlighter.focus()
			onTermLostFocus: highlighter.unfocus()

			MouseArea {
				anchors.fill: parent
				acceptedButtons: Qt.NoButton
				onWheel: { }
			}

			Component.onCompleted: {
				forceActiveFocus();
				session.startShellProgram();
			}
		}
	}
}
