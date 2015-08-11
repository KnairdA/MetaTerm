function execute(output, command) {
	var msg = function(name) {
		output.log('"' + name + '"' + " is not implemented.");
	};
	var args = command.split(' ');

	try {
		var closure = eval(args[0]);

		if ( typeof closure === "function" ) {
			args.shift();
			closure(output, args);
		} else {
			msg(args[0]);
		}
	} catch (exception) {
		msg(args[0]);
	}
}

function exec(output, args) {
	var result = eval(args.join(' '));

	if ( typeof result !== "undefined" ) {
		output.log(result);
	} else {
		output.log('');
	}
}

function jump(output, index) {
	terminalList.selectItem(index);
}

function next() {
	terminalList.selectNext();
}

function prev() {
	terminalList.selectPrev();
}

