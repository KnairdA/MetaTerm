import QtQuick 2.0
import QtQuick.Controls 1.2
import Qt.labs.settings 1.0

Item {
	id: item

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
		shortcut: settings.keybinding.normalMode
		onTriggered: {
			item.state = "NORMAL";

            terminalList.forceActiveFocus();
			terminalList.unfocusCurrent();
			command.unfocus();
		}
	}

	Action {
		id: enterInsertAction
		shortcut: settings.keybinding.insertMode
		onTriggered: {
			item.state = "INSERT";

			terminalList.focusCurrent();
		}
	}

	Action {
		id: enterCommandAction
		shortcut: settings.keybinding.commandMode
		onTriggered: {
			item.state = "COMMAND";

			command.focus(shortcut);
		}
	}

	Action {
		id: nextTerminalAction
		shortcut: settings.keybinding.nextItem
		onTriggered: terminalList.selectNext()
	}

	Action {
		id: heightenTerminalAction
		shortcut: settings.keybinding.heightenItem
		onTriggered: terminalList.getCurrent().heighten()
	}

	Action {
		id: shortenTerminalAction
		shortcut: settings.keybinding.shortenItem
		onTriggered: terminalList.getCurrent().shorten()
	}

	Action {
		id: prevTerminalAction
		shortcut: settings.keybinding.prevItem
		onTriggered: terminalList.selectPrev()
	}

	Action {
		id: lastTerminalAction
		shortcut: settings.keybinding.lastItem
		onTriggered: terminalList.selectItem(terminalList.children.length - 1)
	}

	Action {
		id: firstTerminalAction
		shortcut: settings.keybinding.firstItem
		onTriggered: terminalList.selectItem(0)
	}

	Action {
		id: resetTerminalAction
		shortcut: settings.keybinding.resetItem
		onTriggered: {
			terminalList.getCurrent().reset();
			terminalList.getCurrent().select();
		}
	}
}
