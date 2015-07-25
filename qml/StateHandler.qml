import QtQuick 2.0
import QtQuick.Controls 1.2

Item {
	id: item

	property Item terminalList : null

	state: "INSERT"

	function enterInsertMode() {
		insertTerminalAction.trigger();
	}

	states: [
		State {
			name: "NORMAL"

			PropertyChanges { target: escapeTerminalAction;   enabled: false }
			PropertyChanges { target: insertTerminalAction;   enabled: true  }
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

			PropertyChanges { target: escapeTerminalAction;   enabled: true  }
			PropertyChanges { target: insertTerminalAction;   enabled: false }
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
		id: insertTerminalAction
		shortcut: "i"
		onTriggered: {
			item.state = "INSERT";

			terminalList.focusCurrent();
		}
	}

	Action {
		id: escapeTerminalAction
		shortcut: "Shift+ESC"
		onTriggered: {
			item.state = "NORMAL";

            terminalList.forceActiveFocus();
			terminalList.unfocusCurrent();
		}
	}

	Action {
		id: nextTerminalAction
		shortcut: "j"
		onTriggered: terminalList.selectNext()
	}

	Action {
		id: heightenTerminalAction
		shortcut: "Shift+J"
		onTriggered: terminalList.getCurrent().heighten()
	}

	Action {
		id: shortenTerminalAction
		shortcut: "Shift+K"
		onTriggered: terminalList.getCurrent().shorten()
	}

	Action {
		id: prevTerminalAction
		shortcut: "k"
		onTriggered: terminalList.selectPrev()
	}

	Action {
		id: lastTerminalAction
		shortcut: "Shift+G"
		onTriggered: terminalList.selectItem(terminalList.children.length - 1)
	}

	Action {
		id: firstTerminalAction
		shortcut: "g"
		onTriggered: terminalList.selectItem(0)
	}

	Action {
		id: resetTerminalAction
		shortcut: "d"
		onTriggered: terminalList.getCurrent().reset()
	}
}
