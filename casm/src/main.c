#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#include "data.h"
#include "object.h"
#include "header.h"

int main(int argc, char *argv[]) {
	if (argc == 1) {
		puts(
			"CrypticASM (CASM) Assembler\n" \
			"Usage:\n" \
			"\tcasm -a <code.casm>\tAssemble a file\n" \
			"\tcasm -r <outputfile>\tRun an output file\n" \
			"\tcasm -a <outputfile> -i \"Input\"\tOverride key input with string\n"
			"Examples:\n" \
			"\tcasm -a foo.casm > a.out && casm -r a.out"
		);

		#ifdef EMULATOR_WINDOW
			puts("Compiled with X11 Windowed Emulator.");
		#endif

		printf("Library Directory: %s\n", CASM_LOCATION);
	}

	// Note that we parse backwards.
	char *inputKeys = 0;
	while (argc != 0) {
		argc--;
		if (argv[argc][0] == '-') {
			switch (argv[argc][1]) {
			case 'i':
				inputKeys = argv[argc + 1];
				break;
			case 'l':
				casmLocationS = argv[argc + 1];
				break;
			case 'r':
				return run(argv[argc + 1], inputKeys);
			case 'a':
				return assemble(argv[argc + 1], 0);
			}
		}
	}
	
    return 0;
}
