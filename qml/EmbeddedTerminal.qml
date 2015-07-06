import QtQuick 2.0
import QMLTermWidget 1.0

Item {
	id: item

	property string program
	property string workingDirectory
	property int    columns
	property int    lines

	width:  container.width
	height: container.height

	function select()   { highlighter.select()   }
	function deselect() { highlighter.deselect() }

	Row {
		id: container

		Rectangle {
			id: highlighter

			width: 10
			height: terminal.height

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

		Rectangle {
			width: terminal.width
			height: terminal.height

			color: "#ffffff"

			QMLTermWidget {
				id: terminal

				font.family: "Monospace"
				font.pointSize: 8

				width:  fontMetrics.width  * item.columns
				height: fontMetrics.height * item.lines

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
}
