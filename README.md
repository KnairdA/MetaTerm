# MetaTerm

…is a _prompt like_ user interface enabling running multiple terminal applications at the same time while preserving the sequence of execution. This functionality is controllable in a _vim like_ way in respect of both keybindings and a mode based paradigm.

_MetaTerm_ is implemented in _QML_ and uses [QMLTermWidget](https://github.com/Swordfish90/qmltermwidget) as its embedded terminal emulator.

## Screenshot

![MetaTerm in action](http://static.kummerlaender.eu/media/metaterm_1.png)

## Usage

_MetaTerm_ starts in insert mode which means that one can simply start typing a command and trigger it's execution by pressing _enter_.

The list of running and killed terminal instances is navigable using _vim-like_ keybindings, i.e. using `j` and `k`. Additionally one can jump to the top using `g` and to the bottom using `G`. Navigation is also accessible in command mode via `:next`, `:prev` and `:jump <INDEX>`.

Insert mode may be entered manually using `i` and exited using `Shift+ESC`. The currently selected terminal instance is killable via `d`. Command mode is entered whenever one presses `:` in normal mode.

A list of all running processes and their respective index is exposed via `:ls`.

Settings may be explored and changed using `:set` in command mode, e.g. the window background is changeable via `:set window background <COLOR>`.

Furthermore _MetaTerm_'s command mode exposes a JavaScript prompt through `:exec <COMMAND>`.

## Building

If all requirements are satisfied _MetaTerm_ may be built using a simple chain of _qmake_ and _make_. Alternatively one can also open the provided project file in _QtCreator_.

## Requirements

* [Qt 5](http://qt.io)
* [QMLTermWidget](https://github.com/Swordfish90/qmltermwidget)
