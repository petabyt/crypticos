#ifndef __HEADER
#define __HEADER
int run(char *file, char *keys);
int assemble(char *file, int clean);

int isAlpha(char c);
int isDigit(char c);
int lex(struct Token *tokens, char *string);
int run(char *file, char *keys);

#endif