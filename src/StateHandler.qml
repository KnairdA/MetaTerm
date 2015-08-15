import QtQuick 2.0
import QtQuick.Controls 1.2
import Qt.labs.settings 1.0

Item {
	id: item

	property Item         terminalList : null
	property CommandInput commandInput : null

	Settings {
		id: settings
		category: "keybinding"

		property string insertMode   : "i"
		property string normalMode   : "Shift+ESC"
		property string commandMode  : ":"
		property string nextItem     : "j"
		property string prevItem     : "k"
		property string firstItem    : "g"
		property string resetItem    : "d"
		property string lastItem     : "Shift+G"
		property string heightenItem : "Shift+J"
		property string shortenItem  : "Shift+K"
	}

	state: "INSERT"

	function enterInsertMode() {
		enterInsertAction.trigger();
	}

	function enterNormalMode() {
		enterNormalAction.trigger();
	}

	states: [
		State {
			name: "NORMAL"

			PropertyChanges { target: enterNormalAction;      enabled: false }
			PropertyChanges { target: enterInsertAction;      enabled: true  }
			PropertyChanges { target: enterCommandAction;     enabled: true  }
			PropertyChanges { target: nextTerminalAction;     enabled: true  }
			PropertyChanges { target: heightenTerminalAction; enabled: true  }
			PropertyChanges { target: shortenTerminalAction;  enabled: true  }
			PropertyChanges { target: prevTerminalAction;     enabled: true  }
			PropertyChanges { target: lastTerminalAction;     enabled: true  }
			PropertyChanges { target: firstTerminalAction;    enabled: true  }
			PropertyChanges { target: resetTerminalAction;    enabled: true  }
		},
		State {
			name: "INSERT"

			PropertyChanges { target: enterNormalAction;      enabled: true  }
			PropertyChanges { target: enterInsertAction;      enabled: false }
			PropertyChanges { target: enterCommandAction;     enabled: false }
			PropertyChanges { target: nextTerminalAction;     enabled: false }
			PropertyChanges { target: heightenTerminalAction; enabled: false }
			PropertyChanges { target: shortenTerminalAction;  enabled: false }
			PropertyChanges { target: prevTerminalAction;     enabled: false }
			PropertyChanges { target: lastTerminalAction;     enabled: false }
			PropertyChanges { target: firstTerminalAction;    enabled: false }
			PropertyChanges { target: resetTerminalAction;    enabled: false }
		},
		State {
			name: "COMMAND"

			PropertyChanges { target: enterNormalAction;      enabled: true  }
			PropertyChanges { target: enterInsertAction;      enabled: false }
			PropertyChanges { target: enterCommandAction;     enabled: false }
			PropertyChanges { target: nextTerminalAction;     enabled: false }
			PropertyChanges { target: heightenTerminalAction; enabled: false }
			PropertyChanges { target: shortenTerminalAction;  enabled: false }
			PropertyChanges { target: prevTerminalAction;     enabled: false }
			PropertyChanges { target: lastTerminalAction;     enabled: false }
			PropertyChanges { target: firstTerminalAction;    enabled: false }
			PropertyChanges { target: resetTerminalAction;    enabled: false }
		}
	]

	Action {
		id: enterNormalAction
		shortcut: settings.normalMode
		onTriggered: {
			item.state = "NORMAL";

            terminalList.forceActiveFocus();
			terminalList.unfocusCurrent();
			commandInput.unfocus();
		}
	}

	Action {
		id: enterInsertAction
		shortcut: settings.insertMode
		onTriggered: {
			item.state = "INSERT";

			terminalList.focusCurrent();
		}
	}

	Action {
		id: enterCommandAction
		shortcut: settings.commandMode
		onTriggered: {
			item.state = "COMMAND";

			commandInput.focus(shortcut);
		}
	}

	Action {
		id: nextTerminalAction
		shortcut: settings.nextItem
		onTriggered: terminalList.selectNext()
	}

	Action {
		id: heightenTerminalAction
		shortcut: settings.heightenItem
		onTriggered: terminalList.getCurrent().heighten()
	}

	Action {
		id: shortenTerminalAction
		shortcut: settings.shortenItem
		onTriggered: terminalList.getCurrent().shorten()
	}

	Action {
		id: prevTerminalAction
		shortcut: settings.prevItem
		onTriggered: terminalList.selectPrev()
	}

	Action {
		id: lastTerminalAction
		shortcut: settings.lastItem
		onTriggered: terminalList.selectItem(terminalList.children.length - 1)
	}

	Action {
		id: firstTerminalAction
		shortcut: settings.firstItem
		onTriggered: terminalList.selectItem(0)
	}

	Action {
		id: resetTerminalAction
		shortcut: settings.resetItem
		onTriggered: {
			terminalList.getCurrent().reset();
			terminalList.getCurrent().select();
		}
	}
}
