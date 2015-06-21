import QtQuick 2.0
import QMLTermWidget 1.0
import QtQuick.Controls 1.2

Item {
	id: embeddedTerminal
	property string program
	property string workingDirectory
	property int columns
	property int lines

	width: container.width
	height: container.height

	function focus() { terminal.forceActiveFocus() }

	Row {
		id: container

		Rectangle {
			id: highlighter

			width: 10
			height: terminal.height

			color: "#aadb0f"

			Behavior on opacity {
				NumberAnimation {
					duration: 300
					easing.type: Easing.OutCubic
				}
			}

			function focus()   { opacity = 1 }
			function unfocus() { opacity = 0 }
		}

		Rectangle {
			width: terminal.width
			height: terminal.height

			color: "#ffffff"

			QMLTermWidget {
				id: terminal

				font.family: "Monospace"
				font.pointSize: 8

				width: fontMetrics.width * embeddedTerminal.columns
				height: fontMetrics.height * embeddedTerminal.lines

				session: QMLTermSession {
					initialWorkingDirectory: embeddedTerminal.workingDirectory

					shellProgram: {
						return (embeddedTerminal.program).split(" ")[0];
					}

					shellProgramArgs: {
						var elements = (embeddedTerminal.program).split(" ");
						elements.shift();

						return elements;
					}
				}

				MouseArea {
					anchors.fill: parent
					acceptedButtons: Qt.LeftButton
					onClicked: parent.forceActiveFocus();
					onWheel: { }
				}

				onTermGetFocus: highlighter.focus()
				onTermLostFocus: highlighter.unfocus()

				Component.onCompleted: {
					terminal.forceActiveFocus();
					session.startShellProgram();
				}
			}
		}
	}
}
