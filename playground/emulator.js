// Execute CrytpicASM
var loop;
var a;
function execute(stack, code, speed) {
	a = stack;
	var labels = [];
	var inputChar = 0;

	for (var c = 0; c < code.length; c++) {
		if (code[c] == "|") {
			labels.push(c);
		}
	}

	clearInterval(loop);
	var c = 0;
	if (speed == "fast") {
		var i = 0;
		for (; c < code.length; c++) {
			i++;
			if (i > 10000000) {alert("Passed 10 Million, stopped for safety");}
			execChar();
		}

		output.value += "\nDone.";
		console.log(stack);
	} else if (speed == "slow") {
		loop = setInterval(function() {
			if (c > code.length) {
				output.value += "\nDone.";
				console.log(stack);
				clearInterval(loop);
				return;
			}

			execChar();

			c++;
		}, 0);
	}

	function execChar() {
		switch (code[c]) {
		case '+':
			stack.bottom[stack.bottomP]++;
			break;
		case '*':
			stack.bottom[stack.bottomP] += 5;
			break;
		case '%':
			stack.bottom[stack.bottomP] += 50;
			break;
		case '!':
			stack.bottom[stack.bottomP] = 0;
			break;
		case '-':
			stack.bottom[stack.bottomP]--;
			break;

		case '>':
			stack.bottomP++;
			break;
		case '<':
			stack.bottomP--;
			break;
		case 'd':
			stack.topP++;
			break;
		case 'a':
			stack.topP--;
			break;

		case 'v':
			stack.bottom[stack.bottomP] = stack.top[stack.topP];
			break;
		case '^':
			stack.top[stack.topP] = stack.bottom[stack.bottomP];
			break;

		case '.':
			output.value += String.fromCharCode(
				stack.bottom[stack.bottomP]
			);

			break;
		case ',':
			//console.log(stack.bottomP);
			stack.bottom[stack.bottomP] = input.value[inputChar].charCodeAt(0);
			inputChar++;
			break;
		case '?':
			//console.log(stack.top[stack.topP + 1], stack.top[stack.topP + 2], stack.top[stack.topP]);
			if (stack.top[stack.topP + 1] == stack.top[stack.topP + 2]) {
				c = labels[stack.top[stack.topP]];
			}

			break;
		case '$':
			//console.log(labels[stack.top[stack.topP] - 1]);
			c = labels[stack.top[stack.topP]];
			break;
		}
	}
}
