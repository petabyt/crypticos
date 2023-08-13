// JS Compiler
function lex(string) {
	var tokens = [];

	for (var c = 0; c < string.length; c++) {
		// Skip nothing
		if (" \n\t".includes(string[c])) {
			continue;
		}

		tokens.push({value: "", type: ""});
		var current = tokens[tokens.length - 1];

		if (isAlpha(string[c])) {
			current.type = "text";
			while (isAlpha(string[c])) {
				current.value += string[c];
				c++;
			}

			// Quit on detection of label
			if (string[c] == ":") {
				current.type = "label";
				return tokens;
			}

			// Test for selector "asd[1]"
			if (string[c] == "[") {
				current.selector = "";
				c++;
				while (string[c] != "]") {
					current.selector += string[c];
					c++;
				}
			}
		} else if (string[c] == ";") {
			while (c < string.length) {
				c++;
			}

			// If we have not done any other tokens
			if (tokens.length == 1) {
				return [];
			}
		} else if (isNum(string[c])) {
			current.type = "int";
			while (isNum(string[c])) {
				current.value += string[c];
				c++;
			}

			c--;
		} else if (string[c] == "'") {
			current.type = "char";
			c++;
			current.value = string[c];
			c += 2;

		} else if (string[c] == "\"") {
			current.type = "string";
			c++;
			while (string[c] != "\"") {
				current.value += string[c];
				c++;
			}
		} else if (string[c] == "[") {
			current.type = "location";
			c++;
			while (string[c] != "]") {
				current.value += string[c];
				c++;
			}
		}
	}

	return tokens;
}

function isAlpha(char) {
	if ("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_.".includes(char)) {
		return true;
	} else {
		return false;
	}
}

function isNum(char) {
	if ("0123456789".includes(char)) {
		return true;
	} else {
		return false;
	}
}


function compile(array) {
	var output = "";

	var variables = {};
	var labels = {};

	for (var l = 0; l < array.length; l++) {
		var tokens = lex(array[l]);

		// Skip blank lines
		if (tokens.length == 0) {
			continue;
		}

		if (tokens[0].type == "label") {
			labels[tokens[0].value] = Object.keys(labels).length;
		} else if (tokens[0].value == "inc") {
			// Old node.js code
			var data = fs.readFileSync(tokens[1].value, "utf8");
			var findCode = data.split("\n");
			for (l2 in findCode) {
				array.splice(l, 0, findCode[l2]);
				l++;
			}

			array[l] = "; Ignore";
			l -= findCode.length;
		} else if (tokens[0].type == "text" && tokens[0].value == "call") {
			labels[l] = Object.keys(labels).length;
		}
	}

	var memoryUsed = 0;
	var memoryPlace = 0;

	for (var l = 0; l < array.length; l++) {
		var tokens = lex(array[l]);

		// Skip blank lines
		if (tokens.length == 0) {
			continue;
		}

		if (tokens[0].type == "label") {
			output += "|";
			continue;
		}

		switch(tokens[0].value) {
		case "var":
			output += "!"; // Reset value just in case
			if (tokens[2].type == "text") {
				runAt(rawPosition(tokens[2]), "^");
				output += "v";
			} else {
				output += putChar(parseTokenData(tokens[2]));
			}

			output += ">"; // navigate to next cell

			var length = 1; // Single char

			variables[tokens[1].value] = {
				length: length,
				position: memoryUsed
			}

			memoryUsed += length;
			memoryPlace += length;
			break;
		case "arr":
			var length = eval(tokens[2].value); // Find array length

			output += ">".repeat(length);

			variables[tokens[1].value] = {
				length: length,
				position: memoryUsed
			}

			memoryUsed += length;
			memoryPlace += length;
			break;
		case "prt":
			if (tokens[1].type == "string") {
				// A little bit of optmization.
				// characters won't be added in twice.
				// Ex: two 'l's in hello
				var lastChar = -1; // Don't recognise last value
				for (var i = 0; i < tokens[1].value.length; i++) {
					if (lastChar != tokens[1].value[i]) {
						// Either reset and add,
						// Or add on from the last char
						// Also, reset first if on first char (last char not set yet)
						if (lastChar == -1 || lastChar.charCodeAt(0) > tokens[1].value[i].charCodeAt(0)) {
							output += "!";
							output += putChar(tokens[1].value[i].charCodeAt(0));
						} else {
							output += putChar(tokens[1].value[i].charCodeAt(0) - lastChar.charCodeAt(0));
						}
					}

					output += ".";
					lastChar = tokens[1].value[i];
				}
			} else if (tokens[1].type == "text") {
				// Variable
				runAt(rawPosition(tokens[1]), ".");
			} else {
				// char or int
				output += "!" + putChar(parseTokenData(tokens[1])) + ".";
			}

			break;
		case "add":
			runAt(
				rawPosition(tokens[1]),
				putChar(parseTokenData(tokens[2]))
			);

			break;
		case "run":
			output += "!"; // Reset for writing
			output += putChar(labels[l]); // copy return location
			output += "^d"; // Up, right (for when return is called), and goto

			output += "!"; // Reset for writing
			output += putChar(labels[tokens[1].value] + 1); // copy return location
			output += "^$"; // Up, right (for when return is called), and goto

			output += "|"; // Put label
			break;
		case "ret":
			output += "a$"; // Goto previous reg.
			break;
		case "set":
			if (tokens[2].type == "text") {
				if (tokens[2].value == "getchar") {
					runAt(rawPosition(tokens[1]), ",");
					continue;
				}

				runAt(rawPosition(tokens[2]), "^");
				runAt(rawPosition(tokens[1]), "v");
			} else if (tokens[2].type == "location") {
				runAt(
					rawPosition(tokens[1]),
					"!" + putChar(memoryPlace - variables[tokens[2].value].position)
				);
			} else if (tokens[2].type == "string") {
				// Convert strings
				var temp = "";
				for (var i = 0; i < tokens[2].value.length; i++) {
					temp += putChar(tokens[2].value[i].charCodeAt(0));
					temp += ">";
				}

				runAt(
					rawPosition(tokens[1]),
					temp
				);
			} else {
				runAt(
					rawPosition(tokens[1]),
					"!" + putChar(parseTokenData(tokens[2]))
				);
			}

			break;
		case "sub":
			runAt(
				rawPosition(checkVariable(tokens[1])),
				"-".repeat(parseTokenData(tokens[2]))
			);

			break;
		case "inl":
			output += tokens[1].value;
			break;
		case "jmp":
			output += "!"; // Reset cell for next adding
			output += putChar(labels[checkLabel(tokens[1]).value]);
			output += "^$";
			break;
		case "equ":
			// Store temp in register 4. Don't go all back since
			// We will use the previous 3 registers
			output += "dd";

			// Copy variable
			output += "!";
			getValue(tokens[1], "^");

			// Copy char
			output += "a!";
			getValue(tokens[2], "^");

			// Copy in label
			output += "a!"
			output += putChar(labels[tokens[3].value]); // put label
			output += "^!";

			// Restore value from register 4
			//output += "dddvaaa"; // old
			output += "?";
			break;
		}

		function getValue(token, code) {
			if (token.type == "text") {
				if (token.value == "getchar") {
					runAt(rawPosition(tokens[1]), ",");
					return;
				} else {
					runAt(rawPosition(token), code);
				}
			} else {
				output += putChar(parseTokenData(token));
				output += code;
			}
		}

		// Run code at after moving to a certain spot, then return.
		function runAt(spot, code) {
			var oldSpot = memoryPlace;
			var movement = moveTo(memoryPlace, spot);
			output += movement[0];
			output += code;

			// Move back to original spot
			var movementBack = moveTo(movement[1], oldSpot);
			output += movementBack[0];

			memoryPlace = movementBack[1];
		}

		function rawPosition(token) {
			var position = 0;
			if (!variables[token.value]) {
				console.error(l + ": Unknown variable name " + token);
			}

			position += variables[token.value].position;
			if (token.selector) {
				position += eval(token.selector);
			}

			return position;
		}

		function checkVariable(token) {
			if (!variables.hasOwnProperty(token.value)) {
				throw new Error(l + ": Unknown variable name " + token.value);
			}

			return token;
		}

		function checkLabel(token) {
			if (!labels.hasOwnProperty(token.value)) {
				throw new Error(l + ": Unknown label name " + token.value);
			}

			return token;
		}
	}

	// Minimize output, remove useless brackets
	while (output.includes("><")) {
		output = output.replace("><", "");
	}

	// Minimize output, remove useless ad.
	while (output.includes("da")) {
		output = output.replace("da", "");
	}

	return output;
}

// Navigate to place in memory
// Returns the output, and where the
// current place in mem is after movement.
function moveTo(from, to) {
	var output = "";
	if (from < to) {
		output += ">".repeat(to - from);
		from += to - from;
	} else if (from > to) {
		output += "<".repeat(from - to);
		from -= from - to;
	}

	return [output, from];
}

function parseTokenData(token) {
	if (token.type == "int") {
		return eval(token.value);
	} else if (token.type == "char") {
		return token.value.charCodeAt(0);
	}
}

// Turn integer into % / * / + ASM
function putChar(code) {
	var out = "";
	while (code != 0) {
		if (code >= 50) {
			out += '%';
			code -= 50;
		} else if (code >= 5) {
			out += '*';
			code -= 5;
		} else {
			out += '+';
			code -= 1;
		}
	}

	return out;
}
