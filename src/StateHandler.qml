import QtQuick 2.0
import QtQuick.Controls 1.2

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

			PropertyChanges { target: enterNormalAction;  enabled: false }
			PropertyChanges { target: enterInsertAction;  enabled: true  }
			PropertyChanges { target: enterCommandAction; enabled: true  }
			PropertyChanges { target: nextAction;         enabled: true  }
			PropertyChanges { target: heightenAction;     enabled: true  }
			PropertyChanges { target: shortenAction;      enabled: true  }
			PropertyChanges { target: prevAction;         enabled: true  }
			PropertyChanges { target: lastAction;         enabled: true  }
			PropertyChanges { target: firstAction;        enabled: true  }
			PropertyChanges { target: resetAction;        enabled: true  }
			PropertyChanges { target: killAction;         enabled: true  }
		},
		State {
			name: "INSERT"

			PropertyChanges { target: enterNormalAction;  enabled: true  }
			PropertyChanges { target: enterInsertAction;  enabled: false }
			PropertyChanges { target: enterCommandAction; enabled: false }
			PropertyChanges { target: nextAction;         enabled: false }
			PropertyChanges { target: heightenAction;     enabled: false }
			PropertyChanges { target: shortenAction;      enabled: false }
			PropertyChanges { target: prevAction;         enabled: false }
			PropertyChanges { target: lastAction;         enabled: false }
			PropertyChanges { target: firstAction;        enabled: false }
			PropertyChanges { target: resetAction;        enabled: false }
			PropertyChanges { target: killAction;         enabled: false }
		},
		State {
			name: "COMMAND"

			PropertyChanges { target: enterNormalAction;  enabled: true  }
			PropertyChanges { target: enterInsertAction;  enabled: false }
			PropertyChanges { target: enterCommandAction; enabled: false }
			PropertyChanges { target: nextAction;         enabled: false }
			PropertyChanges { target: heightenAction;     enabled: false }
			PropertyChanges { target: shortenAction;      enabled: false }
			PropertyChanges { target: prevAction;         enabled: false }
			PropertyChanges { target: lastAction;         enabled: false }
			PropertyChanges { target: firstAction;        enabled: false }
			PropertyChanges { target: resetAction;        enabled: false }
			PropertyChanges { target: killAction;         enabled: false }
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
		id: nextAction
		shortcut: settings.keybinding.nextItem
		onTriggered: terminalList.selectNext()
	}

	Action {
		id: heightenAction
		shortcut: settings.keybinding.heightenItem
		onTriggered: terminalList.getCurrent().heighten()
	}

	Action {
		id: shortenAction
		shortcut: settings.keybinding.shortenItem
		onTriggered: terminalList.getCurrent().shorten()
	}

	Action {
		id: prevAction
		shortcut: settings.keybinding.prevItem
		onTriggered: terminalList.selectPrev()
	}

	Action {
		id: lastAction
		shortcut: settings.keybinding.lastItem
		onTriggered: terminalList.selectItem(terminalList.children.length - 1)
	}

	Action {
		id: firstAction
		shortcut: settings.keybinding.firstItem
		onTriggered: terminalList.selectItem(0)
	}

	Action {
		id: resetAction
		shortcut: settings.keybinding.resetItem
		onTriggered: {
			terminalList.getCurrent().reset();
			terminalList.getCurrent().select();
		}
	}

	Action {
		id: killAction
		shortcut: settings.keybinding.killItem
		onTriggered: {
			terminalList.getCurrent().terminate();
		}
	}
}
