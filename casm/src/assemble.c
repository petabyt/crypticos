#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "object.h"
#include "data.h"
#include "header.h"

// Preprocessor
#define P_DEFINE "define"
#define P_IFDEF "ifdef"
#define P_IFNDEF "ifndef"
#define P_END "end"
#define P_EXIT "exit"
#define P_ERROR "error"
#define P_UNDEF "undef"
#define P_SYSTEM "system"

// Instruction table
#define I_VAR "var"
#define I_ARR "arr"
#define I_GOT "got"
#define I_PRT "prt"
#define I_INL "inl"
#define I_SUB "sub"
#define I_ADD "add"
#define I_JMP "jmp"
#define I_EQU "equ"
#define I_SET "set"
#define I_RUN "run"
#define I_RET "ret"
#define I_INC "inc"
#define I_FRE "fre"

// Recursive file reader variables
char buffer[MAX_LINE];
FILE *readerStack[3];
int readerPoint = 0;

// Main assembler
struct Memory memory;
struct Token tokens[MAX_TOK];
int skippingLine = 0;
char *casmLocationS = CASM_LOCATION;
int line = 0;

// Main instruction out function
// (send to stdout for now)
void out(char *string) {
	printf("%s", string);
}

void print_error(char error[]) {
	// Only put '\n' if output
	// has been given
	if (line != 0) {
		putchar('\n');
	}
	
	fprintf(stderr, "~ERR on line %d: %s~\n", line + 1, error);
}

// Free entirety of file reader stack
void file_kill() {
	while (readerPoint != 0) {
		fclose(readerStack[readerPoint]);
		readerPoint--;
	}
}

// Check end of current file
int file_next() {
	fileNext_top:
	if (fgets(buffer, MAX_LINE, readerStack[readerPoint]) == NULL) {
		fclose(readerStack[readerPoint]);
		if (line == 0) {
			print_error("Skipping bad file");
			readerPoint--;
		}

		if (readerPoint == 0) {
			return 0; // End of read
		} else {
			readerPoint--;

			// Recursively jump to skip include
			// (We don't want a return value)
			goto fileNext_top;
		}
	}

	return 1;
}

// Pause current file reading, open new one
void file_open(char *file) {
	line++; // To skip to line after inc
	readerPoint++;

	// Note: '$' is library location
	if (file[0] == '$') {
		char location[128];
		strcpy(location, casmLocationS);
		strcat(location, file + 1);
		readerStack[readerPoint] = fopen(location, "r");
	} else {
		readerStack[readerPoint] = fopen(file, "r");
	}
	
	if (readerStack[readerPoint] == NULL) {
		print_error("Skipping bad file included");
		readerPoint--;
	}
}

void kill_all() {
	free(memory.d);
	file_kill();
}

void put_int(int value) {
	// Optimize 48 as
	// !%--, not
	// !*********+++
	while (value != 0) {
		if (value >= 45) {
			out("%");
			value -= 50;
		} else if (value >= 5) {
			out("*");
			value -= 5;
		} else {
			out("+");
			value--;
		}

		while (value < 0) {
			out("-");
			value++;
		}
	}
}

// Locate variable, array, label, from objects in memory from type
int locate_object(char *name, int type) {
	for (int i = 0; i < memory.length; i++) {
		// Make sure to check type first. Name can sometimes be unitialized.
		if (memory.d[i].type == type && !strcmp(memory.d[i].name, name)) {
			return i;
		}
	}

	return -1;
}

// Go to a specific spot in memory
void got(int place) {
	if (place > memory.position) {
		while (place != memory.position) {
			out(">");
			memory.position++;
		}
	} else if (place < memory.position) {
		while (place != memory.position) {
			out("<");
			memory.position--;
		}
	}
}

// Move to location of variable
void got_var(char *var) {
	int location = locate_object(var, VAR);
	if (location == -1) {
		print_error("Variable not found");
		kill_all();
		exit(1);
	}
	
	got(memory.d[location].location);
}

// Put/got a token, ready for "^" to be used.
void put_tok(struct Token *token, int reset) {
	if (token->type == DIGIT) {
		if (reset) {
			got(memory.used);
		}
		
		out("!");
		put_int(token->value);
	} else if (token->type == TEXT) {
		got_var(token->text);
	}
}

int run_preproc() {
	if (tokens[0].type != PREPROC) {
		return skippingLine;
	}
	
	// Very basic preprocessor
	if (!strcmp(tokens[0].text, P_IFDEF)) {
		int tryDef = locate_object(tokens[1].text, DEFINE);
		if (tryDef == -1) {
			skippingLine = 1;
		}
	} else if (!strcmp(tokens[0].text, P_IFNDEF)) {
		int tryDef = locate_object(tokens[1].text, DEFINE);
		if (tryDef != -1) {
			skippingLine = 1;
		}
	} else if (!strcmp(tokens[0].text, P_END)) {
		skippingLine = 0;
	} else if (!strcmp(tokens[0].text, P_DEFINE)) {
		strcpy(memory.d[memory.length].name, tokens[1].text);
		memory.d[memory.length].location = tokens[2].value;
		memory.d[memory.length].type = DEFINE;
		memory.length++;
	} else if (!strcmp(tokens[0].text, P_UNDEF)) {
		int tryDef = locate_object(tokens[1].text, DEFINE);
		if (tryDef != -1) {
			memory.d[tryDef].type = 0;
		}
	}

	return skippingLine;
}

// Return 0/1 for good/bad assemble
int assemble(char *file, int clean) {
	memory.length = 0;
	memory.used = 0;
	memory.position = 0;

	// Open initial file at zero.
	// (first, before allocations)
	readerStack[0] = fopen(file, "r");
	if (readerStack[0] == NULL) {
		print_error("File not found");
		return 1;
	}

	// Use ~32k ram for memory objects
	memory.d = malloc(sizeof(struct MemObject) * MAX_MEMOBJ);
	if (memory.d == NULL) {puts("Alloc error"); return 1;}

	// Default variable WKSP. Takes no space, only
	// set to workspace location.
	strcpy(memory.d[memory.length].name, "WKSP");
	memory.d[memory.length].type = VAR;
	memory.length++;

	for (int i = 1; i < MAX_MEMOBJ; i++) {
		memory.d[i].type = EMPTY;
	}
	
	// Pre-lex time - lex through
	// the labels,runs,incs first.
	int labelsFound = 0;
	while (file_next()) {
		int length = lex(tokens, buffer);
		if (length == 0) {
			continue;
		}

		// Preprocessor must be run here
		// to ignore labels/includes
		if (run_preproc()) {
			continue;
		}

		// System shell calls should not be called
		// on pre lex
		if (!strcmp(tokens[0].text, P_SYSTEM)) {
			system(tokens[1].text);
		}

		if (tokens[0].type == LABEL) {
			strcpy(memory.d[memory.length].name, tokens[0].text);
			memory.d[memory.length].location = labelsFound;
			memory.d[memory.length].type = LABEL;
			memory.length++;
			labelsFound++;
		} else if (tokens[0].type == TEXT && !strcmp(tokens[0].text, "run")) {
			memory.d[memory.length].location = line;
			memory.d[memory.length].length = labelsFound; // Remember labelsFound is stored in length.
			memory.d[memory.length].type = RUN;
			memory.length++;
			labelsFound++;
		} else if (!strcmp(tokens[0].text, "inc")) {
			file_open(tokens[1].text);
			continue;
		}

		line++;
	}

	// Undefine everything after Pre-lex
	for (int i = 0; i < memory.length; i++) {
		if (memory.d[i].type == DEFINE) {
			memory.d[i].type = 0;
		}
	}

	// Close and reopen to pointer
	readerPoint = 0;
	readerStack[readerPoint] = fopen(file, "r");	
	
	// Lex regular instructions
	line = 0;
	while (file_next()) {
		int length = lex(tokens, buffer);
		if (length == 0) {
			continue;
		}

		if (run_preproc()) {
			continue;
		}

		// Assemble time extra preprocessor features
		if (tokens[0].type == PREPROC) {
			if (!strcmp(tokens[0].text, P_ERROR)) {
				print_error(tokens[1].text);
				kill_all();
				return 0;
			} else if (!strcmp(tokens[0].text, P_EXIT)) {
				kill_all();
				return 0;
			}
		}

		// Set default variable WKSP before
		// assembling each line
		memory.d[0].location = memory.used;

		// Replace tokens. Replace defined keywords
		// with their values, replace
		for (int i = 0; i < length; i++) {
			if (tokens[i].type == TEXT) {
				int tryDef = locate_object(tokens[i].text, DEFINE);
				if (tryDef != -1) {
					tokens[i].type = DIGIT;
					tokens[i].value = memory.d[tryDef].location;
				}
			} if (tokens[i].type == ADDRESSOF) {
				// For variables get location, for labels get ID
				// (occurence in output file)
				tokens[i].type = DIGIT;
				int location = locate_object(tokens[i].text, VAR);
				if (location == -1) {
					location = locate_object(tokens[i].text, LABEL);
					if (location == -1) {
						print_error("Bad request for addressof");
						goto kill;
					} else {
						// Label
						tokens[i].value = memory.d[location].location;
					}
				} else {
					// Variable
					// +1 How far back the variable is. Must be after it.
					tokens[i].value = memory.used - memory.d[location].location;
				}
			}
		}

		// If label, it is already added.
		if (tokens[0].type == LABEL) {
			if (tokens[0].text[0] != '_') {
				got(memory.used);
			}
			
			out("|");
			line++;
			continue;
		}

		// Now, assemble actual instructions
		if (!strcmp(tokens[0].text, I_VAR)) {
			// Find a 
			int location = memory.length;
			for (int i = 0; i < memory.length; i++) {
				if (memory.d[i].type == EMPTY) {
					location = i;
					break;
				}
			}
		
			// Add variable into object list
			strcpy(memory.d[location].name, tokens[1].text);
			memory.d[location].location = memory.used;
			memory.d[location].length = 1; // vars are 1 int wide
			memory.d[location].type = VAR;

			// Use if we did not find an available spot
			if (location == memory.length) {
				memory.length++;
			}

			// Allow variables to be unitialized if no value
			// is specified
			if (length != 2) {
				// Go to the variable's spot in memory
				// In order to add value to it.
				got(memory.used);
				out("!"); // Reset unitialized value
				put_int(tokens[2].value);
			}

			memory.used += 1;
		} else if (!strcmp(tokens[0].text, "arr")) {
			// Add variable into object list
			strcpy(memory.d[memory.length].name, tokens[1].text);
			memory.d[memory.length].location = memory.used;
			memory.d[memory.length].length = tokens[2].value;
			memory.d[memory.length].type = VAR;
			memory.length++;

			// Add up the memory used.
			memory.used += tokens[2].value;

			// Initialize the array if a fourth
			// token is specified. Can be zeros.
			if (length > 3) {
				// If not zero, copy the value instead of making
				// it again every time.
				if (tokens[3].value == 0) {
					while (tokens[2].value != 0) {
						out("!>");
						memory.position++;
						tokens[2].value--;
					}
				} else {
					out("!");
					put_int(tokens[3].value);
					out("^>");
					while (tokens[2].value != 0) {
						out("v>");
						memory.position++;
						tokens[2].value--;
					}
				}
			}
		} else if (!strcmp(tokens[0].text, I_GOT)) {
			if (tokens[1].type == TEXT) {
				got_var(tokens[1].text);
			} else if (tokens[1].type == DIGIT) {
				got(tokens[1].value);
			}
		} else if (!strcmp(tokens[0].text, I_PRT)) {
			if (tokens[1].type == STRING) {
				got(memory.used);

				// The string printing algorithm is enhanced and optimized.
				for (int i = 0; tokens[1].text[i] != '\0'; i++) {
					if (i != 0) {
						if (tokens[1].text[i - 1] < tokens[1].text[i]) {
							put_int(tokens[1].text[i] - tokens[1].text[i - 1]);
							out(".");
							continue;
						} else if (tokens[1].text[i - 1] == tokens[1].text[i]) {
							out(".");
							continue;
						}

						// NOTE: Else go down below
					}

					out("!");
					put_int(tokens[1].text[i]);
					out(".");
				}
			} else {
				put_tok(&tokens[1], 1);
				out(".");
			}
		} else if (!strcmp(tokens[0].text, I_INL)) {
			if (tokens[1].type == STRING) {
				out(tokens[1].text);
			} else {
				print_error("Expected STRING for INL");
				goto kill;
			}
		} else if (!strcmp(tokens[0].text, I_SUB)) {
			got_var(tokens[1].text);

			// Since there are no %*+ for subtract, we must
			// do solely -s instead.
			while (tokens[2].value != 0) {
				out("-");
				tokens[2].value--;
			}
			
		} else if (!strcmp(tokens[0].text, I_ADD)) {
			got_var(tokens[1].text);
			put_int(tokens[2].value);
		} else if (!strcmp(tokens[0].text, I_JMP)) {
			int location = locate_object(tokens[1].text, LABEL);
			if (location == -1) {
				print_error("Label not found");
				goto kill;
			}

			got(memory.used);
			out("!"); // Reset current working space cell
			put_int(memory.d[location].location);
			out("^"); // UP
			out("$"); // JMP
		} else if (!strcmp(tokens[0].text, I_EQU)) {
			out("dd"); // Next two are needed as compare values
			put_tok(&tokens[1], 1);
			out("^a"); // UP, from second to first compare value
			
			put_tok(&tokens[2], 1);
			out("^a"); // UP, from second to first compare value
			
			int location = locate_object( tokens[3].text, LABEL);
			if (location == -1) {
				print_error("Label not found");
				goto kill;
			}

			got(memory.used);

			out("!"); // Reset current working space cell
			put_int(memory.d[location].location);
			out("^"); // UP
			out("?"); // EQU
		} else if (!strcmp(tokens[0].text, I_SET)) {
			if (tokens[1].type == TEXT && tokens[2].type == TEXT) {
				got_var(tokens[2].text);
				out("^");
				got_var(tokens[1].text);
				out("v");
			} else {
				got_var(tokens[1].text);
				put_tok(&tokens[2], 0);
			}
		} else if (!strcmp(tokens[0].text, I_RUN)) {
			// Find run label
			int i;
			for (i = 0; i < memory.length; i++) {
				// Check type and line in source code.
				if (memory.d[i].type == RUN && memory.d[i].location == line) {
					break;
				}
			}

			got(memory.used); // Go back to original spot
			out("!"); // Reset current working space cell

			// The label number is stored in length
			// (doesn't make sense, but it is fine)
			put_int(memory.d[i].length);
			out("^d"); // UP, Next top cell
			out("!"); // Reset current working space cell

			// Find label like JMP
			int location = locate_object(tokens[1].text, LABEL);
			if (location == -1) {
				print_error("Label not found");
				goto kill;
			}

			put_int(memory.d[location].location);
			out("^"); // UP
			out("$"); // JMP
			out("|"); // Put the label for the run command
		} else if (!strcmp(tokens[0].text, I_RET)) {
			got(memory.used); // Go back to original spot
			out("a$"); // BACK, JMP
		} else if (!strcmp(tokens[0].text, I_INC)) {
			file_open(tokens[1].text);
			continue;
		} else if (!strcmp(tokens[0].text, I_FRE)) {
			int location = locate_object(tokens[1].text, VAR);
			memory.d[location].type = EMPTY;
			memory.used--;
		}

		line++;
		if (clean) {
			out("\n");
		}
	}

	kill_all(&memory);
	return 0;
	
	kill:
	kill_all(&memory);
	return 1;
}
