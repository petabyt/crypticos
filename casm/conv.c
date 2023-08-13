// Convert program into 4 bit bytecode,
// therefore compressing the program in half

// This not actually used, just a demo.

#include <stdio.h>
#include <stdlib.h>

char inst[] = "!%*+-<>ad^v.,$?|";

int getChar(char a) {
	int c;
	for (c = 0; inst[c] != a && inst[c] != '\0'; c++);
	return c;
}

int main(int argc, char *argv[]) {
	for (int i = 0; argv[1][i] != '\0'; i++) {
		int a = getChar(argv[1][i]);
		i++;
		int b = getChar(argv[1][i]);
		printf("%d, ", (a << 4) | b);
	}

	return 0;
}
