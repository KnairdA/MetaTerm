function execute(command) {
	var args = command.split(' ');
	var func = args[0];
	args.shift();

	eval(func + '(' + JSON.stringify(args) + ')');
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
