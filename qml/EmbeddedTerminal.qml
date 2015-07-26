import QtQuick 2.0
import QMLTermWidget 1.0
import QtQuick.Layouts 1.1
import Qt.labs.settings 1.0

Item {
	id: item

	property string program
	property string workingDirectory

	property int    lines      : 20
	property int    frameWidth : 10

	height: terminal.height
	width:  parent.width - frameWidth

	Settings {
		category: "terminal"

		property alias frameWidth  : item.frameWidth
		property alias colorScheme : terminal.colorScheme
		property alias fontFamily  : terminal.font.family
		property alias fontSize    : terminal.font.pointSize
	}

	function select()   { highlighter.select()   }
	function deselect() { highlighter.deselect() }

	RowLayout {
		id: container

		anchors {
			left:  parent.left
			right: parent.right
		}

		spacing: 0

		Highlighter {
			id: highlighter

			width: item.frameWidth
			Layout.fillHeight: true
		}

		QMLTermWidget {
			id: terminal

			font {
				family: "Monospace"
				pointSize: 8
			}

			Layout.fillWidth:       true
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

			onTermGetFocus:  highlighter.focus()
			onTermLostFocus: highlighter.unfocus()

			MouseArea {
				anchors.fill: parent
				acceptedButtons: Qt.NoButton
				onWheel: { }
			}

			Component.onCompleted: {
				forceActiveFocus();
				highlighter.select();
				session.startShellProgram();
			}
		}
	}
}
