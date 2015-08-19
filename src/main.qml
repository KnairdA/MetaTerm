import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

ApplicationWindow {
	id: root

	visible: true
	color: settings.window.background

	Component.onCompleted: {
		terminalList.createItem();
		terminalList.focusCurrent();
	}

	SettingsHandler {
		id: settings
	}

	StateHandler {
		id: mode
	}

	ColumnLayout {
		anchors.fill: parent

		TerminalList {
			id: terminalList

			Layout.fillHeight: true
			Layout.fillWidth:  true
		}

		CommandInput {
			id: command

			Layout.fillWidth: true

			onExecuted: mode.enterNormalMode()
		}
	}
}
