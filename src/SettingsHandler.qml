import QtQuick 2.0
import Qt.labs.settings 1.0

QtObject {
	property Settings window : Settings {
		category: "window"

		property string background : "#161616"
	}

	property Settings keybinding : Settings {
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

	property Settings item : Settings {
		category: "item"

		property int    fontSize   : 18
		property string fontFamily : "Monospace"
		property string fontColor  : "white"
	}

	property Settings highlighter : Settings {
		category: "highlighter"

		property string defaultColor : "#909636"
		property string focusColor   : "#352F6A"
	}

	property Settings terminal : Settings {
		category: "terminal"

		property int    initialLines      : 20
		property int    frameWidth        : 10
		property int    fontSize          : 8
		property string fontFamily        : "Monospace"
		property string colorScheme       : "cool-retro-term"
		property string overlayBackground : "black"
		property string overlayFontColor  : "white"
	}

	property Settings command : Settings {
		category: "command"

		property string background : "black"
		property int    fontSize   : 12
		property string fontFamily : "Monospace"
		property string fontColor  : "white"
		property string errorColor : "red"
	}
}