function execute(command) {
	var msg = function(name) {
		console.log('"' + name + '"' + " is not implemented.");
	};
	var args = command.split(' ');

	try {
		var closure = eval(args[0]);

		if ( typeof closure === "function" ) {
			args.shift();
			closure(args);
		} else {
			msg(args[0]);
		}
	} catch (exception) {
		msg(args[0]);
	}
}

function exec(args) {
	eval(args.join(' '));
}

function next() {
	terminalList.selectNext();
}

function prev() {
	terminalList.selectPrev();
}

function jump(index) {
	terminalList.selectItem(index);
}
