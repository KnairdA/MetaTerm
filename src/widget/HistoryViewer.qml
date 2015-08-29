import QtQuick 2.0
import QMLTermWidget 1.0
import QtQuick.Layouts 1.1

Item {
	id: item

	property string history

	height: viewer.height
	width:  parent.width - settings.terminal.frameWidth

	Text {
		id: viewer

		anchors {
			left:  parent.left
			leftMargin: settings.terminal.frameWidth
			right: parent.right
		}

		color: settings.item.fontColor

		font {
			family:    settings.terminal.fontFamily
			pointSize: settings.terminal.fontSize
		}

		Layout.fillWidth: true

		text: history.trim()
	}
}
