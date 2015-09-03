import QtQuick 2.0
import QMLTermWidget 1.0
import QtQuick.Layouts 1.1

Item {
	id: item

	property string history

	height: viewer.height
	width:  parent.width - settings.terminal.frameWidth

	TextEdit {
		id: viewer

		anchors {
			left:  parent.left
			leftMargin: settings.terminal.frameWidth
			right: parent.right
		}

		Layout.fillWidth: true

		font {
			family:    settings.terminal.fontFamily
			pointSize: settings.terminal.fontSize
		}

		color:             settings.item.fontColor
		selectionColor:    settings.item.fontColor
		selectedTextColor: settings.window.background

		selectByMouse: true
		readOnly:      true

		wrapMode: TextEdit.Wrap

		text: history.trim()
	}
}
