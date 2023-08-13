#include <string.h>
#include <stdbool.h>
#include "object.h"
#include "data.h"

int isAlpha(char c) {
	if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c == '.' || c == '_')) {
		return 1;
	} else {
		return 0;
	}
}

int isDigit(char c) {
	if (c >= '0' && c <= '9') {
		return 1;
	} else {
		return 0;
	}
}

// Lex single line, then quit
int lex(struct Token *tokens, char *string) {
	int c = 0;
	int token = 0;
	while (string[c] != '\0') {
		// Skip chars
		while (string[c] == ' ' || string[c] == '\t') {
			c++;
		}

		// Skip comments
		if (string[c] == ';') {
			while (string[c] != '\n' || string[c] == '\0') {
				c++;
			}
		}

		// Check if this is a nothing line (comments, blank)
		if (string[c] == '\n' || string[c] == '\0') {
			line++;
			return token;
		}

		tokens[token].length = 0;
		tokens[token].type = 0;
		tokens[token].value = 0;
		
		if (isAlpha(string[c]) || string[c] == '#') {
			if (string[c] == '#') {
				tokens[token].type = PREPROC;
				c++;
			} else {
				tokens[token].type = TEXT;
			}
			
			while (isAlpha(string[c])) {
				tokens[token].text[tokens[token].length] = string[c];
				tokens[token].length++;

				c++;
			}

			if (string[c] == ':') {
				tokens[token].type = LABEL;
				c++;
			}
		} else if (isDigit(string[c])) {
			tokens[token].type = DIGIT;
			while (isDigit(string[c])) {
				tokens[token].value *= 10;
				tokens[token].value += (string[c] - '0');
				c++;
			}
		} else if (string[c] == '\'') {
			tokens[token].type = DIGIT;
			c++;
			tokens[token].value = string[c];
			c += 2; // Skip ' and goto next char
		} else if (string[c] == '[') {
			tokens[token].type = ADDRESSOF;
			c++;
			while (string[c] != ']') {
				tokens[token].text[tokens[token].length] = string[c];
				tokens[token].length++;
				c++;
			}

			c++; // Skip ]
		} else if (string[c] == '"') {
			tokens[token].type = STRING;
			c++; // Skip "
			while (string[c] != '"') {
				if (string[c] == '\\') {
					c++;

					switch (string[c]) {
					case 'n':
						string[c] = '\n';
						break;
					case 't':
						string[c] = '\t';
						break;
					case '0':
						string[c] = '\0';
						break;
					case '"':
						string[c] = '"';
						break;
					}
				}
				
				tokens[token].text[tokens[token].length] = string[c];
				tokens[token].length++;
				c++;
			}

			c++; // Skip "
		}

		// Always null terminate string
		tokens[token].text[tokens[token].length] = '\0';
		token++;
	}
	
	return token;
}
