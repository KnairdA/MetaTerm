function execute(output, command) {
	var notImplemented = function(name) {
		output.error('"' + name + '"' + ' is not implemented.');
	};
	var args = command.split(' ');

	try {
		var closure = eval(args[0]);

		if ( typeof closure === 'function' ) {
			args.shift();
			closure(output, args);
		} else {
			notImplemented(args[0]);
		}
	} catch (exception) {
		notImplemented(args[0]);
	}
}

function exec(output, args) {
	try {
		var result = eval(args.join(' '));

		if ( typeof result !== 'undefined' ) {
			output.log(result);
		}
	} catch (exception) {
		output.error(exception);
	}
}

function jump(output, index) {
	terminalList.selectItem(index);
}

function kill(output, index) {
	terminalList.get(index).reset();
}

function next() {
	terminalList.selectNext();
}

function prev() {
	terminalList.selectPrev();
}

function ls(output) {
	terminalList.iterate(function(item) {
		if ( item.terminal !== null ) {
			output.log(item.index + ': ' + item.terminal.program);
		}
	});
}
