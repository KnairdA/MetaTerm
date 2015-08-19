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

function safeEval(output, code) {
	try {
		var result = eval(code);

		if ( typeof result !== 'undefined' ) {
			output.log(result);
		}
	} catch (exception) {
		output.error(exception);
	}
}

function exec(output, args) {
	safeEval(output, args.join(' '));
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

function set(output, args) {
	switch ( args.length ) {
		case 2: {
			safeEval(output, 'settings.' + args[0] + '.' + args[1]);
			break;
		}
		case 3: {
			safeEval(
				output,
				'settings.' + args[0] + '.' + args[1] + ' = "' + args[2] + '"'
			);
			break;
		}
		default: {
			output.error('Wrong count of arguments.');
			break;
		}
	}
}
