import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import Qt.labs.settings 1.0

ApplicationWindow {
	id: root

	visible: true

	Settings {
		id: settings
		category: "window"

		property color background  : "#161616"
	}

	color: settings.background

	Component.onCompleted: {
		terminalList.createItem();
		terminalList.focusCurrent();
	}

	ColumnLayout {
		anchors.fill: parent

		TerminalList {
			id: terminalList

			state: state

			Layout.fillHeight: true
			Layout.fillWidth:  true
		}

		CommandInput {
			id: command

			Layout.fillWidth: true

			onExecuted: state.enterNormalMode()
		}
	}

	StateHandler {
		id: state

		terminalList: terminalList
		commandInput: command
	}
}
