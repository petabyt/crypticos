#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

// Types for 
enum Tokens {
	MULT,
	ADD,
	INTEGER,
	TEXT,  
	PAREN_LEFT,
	PAREN_RIGHT,
	SEMICOLON,
	EQUAL,
	FILE_END,
	BRACKET_LEFT,
	BRACKET_RIGHT,
	FUNCTION,
	VAR
};

enum Parse {
	PARSE_ERR,
	PARSE_EOS, // (end of statement)
	PARSE_EOF,
	
	PARSE_END, // }

	// Block statements
	PARSE_EQU,
	PARSE_NEQU,
	PARSE_LOOP
};

struct Token {
	int type;
	int value; // Also length
	char string[20];
};

int lex(struct Token *reading, char string[], size_t *c);
int parse(size_t *c, struct Token *tokens, size_t *token, char string[]);
