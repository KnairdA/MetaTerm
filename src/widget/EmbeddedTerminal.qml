import QtQuick 2.0
import QMLTermWidget 1.0
import QtQuick.Layouts 1.1

Item {
	id: item

	signal finished

	property string program

	property int   lines   : settings.terminal.initialLines
	property alias history : session.history

	function getPID()    { return session.getShellPID()  }
	function terminate() { return session.sendSignal(15) }

	function select()         { highlighter.select()     }
	function deselect()       { highlighter.deselect()   }
	function displayOverlay() { overlay.displayBriefly() }

	height: terminal.parent.height
	width:  parent.width - settings.terminal.frameWidth

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

		ColumnLayout {
			Layout.fillWidth: true

			spacing: 0

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
					id: session

					initialWorkingDirectory: settings.terminal.initialWorkingDirectory

					shellProgram: settings.terminal.launcherProgram
					shellProgramArgs: [ settings.terminal.launcherArgument, program ]

					onFinished: {
						clearScreen();
						item.finished();
					}
				}

				Component.onCompleted: {
					forceActiveFocus();
					highlighter.select();
					session.startShellProgram();
					statusLine.update();
					overlay.enabled = true;
				}

				onTermGetFocus: {
					highlighter.focus();
					statusLine.update();
				}

				onTermLostFocus: highlighter.unfocus()
				onHeightChanged: overlay.displayBriefly()
				onWidthChanged:  overlay.displayBriefly()

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

			RowLayout {
				id: statusLine

				Layout.fillWidth: true
				Layout.alignment: Qt.AlignRight

				spacing: 5

				function update() {
					var shellPID = session.getShellPID();

					pid.text              = shellPID;
					workingDirectory.text = cwd.currentOfPID(shellPID);
				}

				Text {
					id: pid

					font {
						family:    settings.terminal.fontFamily
						pointSize: settings.terminal.fontSize
					}
					color: settings.terminal.statusFontColor
				}

				Text {
					font {
						family:    settings.terminal.fontFamily
						pointSize: settings.terminal.fontSize
					}
					color: settings.terminal.statusFontColor

					text: "@"
				}

				Text {
					id: workingDirectory

					font {
						family:    settings.terminal.fontFamily
						pointSize: settings.terminal.fontSize
					}
					color: settings.terminal.statusFontColor
				}
			}
		}
	}
}
