#include "header.h"

bool isAlpha(char c) {
	if (((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')) || c == '.' || c == '&') {
		return 1;
	}

	return 0;
}

bool skipChar(char c) {
	if (c == ' ' || c == '\n' || c == '\t' || c == ',') {return 1;}
	return 0;
}

// Main lexer. Lexes a string from a given point.
int lex(struct Token *reading, char string[], size_t *c) {
	while (1) {
		if (string[*c] == '`') {
			(*c)++;
			while (string[*c] != '`') {
				putchar(string[*c]);
				(*c)++;
			}

			putchar('\n');
			(*c)++;
		} else if (string[*c] == '/' && string[*c + 1] == '/') {
			(*c) += 2;
			while (string[*c] != '\n') {
				(*c)++;
			}

			(*c)++;
		} else if (skipChar(string[*c])) {
			while (skipChar(string[*c])) {
				(*c)++;
			}
		} else {
			break;
		}
	}
	
	reading->type = 0;
	reading->value = 0;

	switch (string[(*c)++]) {
	case '\0':
		reading->type = FILE_END;
		return 0;
	case '{':
		reading->type = BRACKET_LEFT;
		return 0;
	case '}':
		reading->type = BRACKET_RIGHT;
		return 0;
	case '+':
		reading->type = ADD; 
		return 0;
	case '*':
		reading->type = MULT;
		return 0;
	case '(':
		reading->type = PAREN_LEFT;
		return 0;
	case ')':
		reading->type = PAREN_RIGHT;
		return 0;
	case ';':
		reading->type = SEMICOLON;
		return 0;
	case '=':
		reading->type = EQUAL;
		return 0;
	}

	// Nothing matched, go back
	(*c)--;

	// Lex text (function names)
	while (isAlpha(string[*c])) {
		reading->type = TEXT;
		reading->string[reading->value] = string[*c];
		reading->value++;
		(*c)++;
	}

	// Lex strings
	if (string[*c] == '\"') {
		(*c)++;
		while (string[*c] != '\"') {
			reading->type = TEXT;
			reading->string[reading->value] = string[*c];
			reading->value++;
			(*c)++;
		}
	}

	// After parsing string/text, null terminate
	reading->string[reading->value] = '\0';

	if (string[*c] == '\'') {
		(*c)++;
		reading->type = INTEGER;
		reading->value = string[*c];
		(*c) += 2; // Skip 0'

		return 0;
	}

	// Lex numbers
	while (string[*c] >= '0' && string[*c] <= '9') {
		reading->type = INTEGER;
		reading->value *= 10;
		reading->value += string[*c] - '0';
		(*c)++;
	}

	// Return OK
	return 0;
}
