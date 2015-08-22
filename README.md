# MetaTerm

…is a _prompt like_ user interface enabling running multiple terminal applications at the same time while preserving the sequence of execution. This functionality is controllable in a _vim like_ way in respect of both keybindings and a mode based paradigm.

_MetaTerm_ is implemented in _QML_ and uses [QMLTermWidget](https://github.com/Swordfish90/qmltermwidget) as its embedded terminal emulator.

## Screenshot

![MetaTerm in action](http://static.kummerlaender.eu/media/metaterm_1.png)

## Building

If all requirements are satisfied _MetaTerm_ may be built using a simple chain of _qmake_ and _make_. Alternatively one can also open the provided project file in _QtCreator_.

## Requirements

* [Qt 5](http://qt.io)
* [QMLTermWidget](https://github.com/Swordfish90/qmltermwidget)
