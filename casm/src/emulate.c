#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 200

#include "data.h"

#ifdef EMULATOR_WINDOW
	#include "gfx/gfx.h"
#endif

// NOTE: unused parameter expected if
// compiled with windowed mode
int run(char *file, char *keys) {
	FILE *reader = fopen(file, "r");
	if (reader == NULL) {
		puts("ERR: File not found.");
		return 1;
	}

	// Copy file into memory
	char *input = malloc(sizeof(char) * MAX_INPUT);
	char *index = input;
	while (1) {
		int c = fgetc(reader);
		if (feof(reader)) {
			break;
		}

		// If there is an error, print it and kill
		// (errors are thrown in seperated by '~'), for
		// when the programmer does not notice
		if (c == '~') {
			free(input);
			c = fgetc(reader);
			while (c != '~' || feof(reader)) {
				putchar((char)c);
				c = fgetc(reader);
			}
			
			fclose(reader);
			return 1;
		}

		*index = (char)c;
		index++;
	}

	*index = '\0';
	fclose(reader);

	#ifdef EMULATOR_WINDOW
		struct gfx_window window = gfx_open(SCREEN_WIDTH, SCREEN_HEIGHT, "CrypticOS Emulator");
		struct gfx_interaction ia;
		gfx_setColor(&window, 255, 0, 0);
	#endif

	unsigned short *memtop = calloc(MAX_TOP, sizeof(unsigned short));
	unsigned short *membottom = calloc(MAX_BOTTOM, sizeof(unsigned short));
	int *labels = calloc(MAX_LABELS, sizeof(int));

	unsigned short *topp = memtop;
	unsigned short *bottomp = membottom;

	// Locate labels
	int l = 0;
	for (int c = 0; input[c] != '\0'; c++) {
		if (input[c] == '|') {
			labels[l] = c;
			l++;
		}
	}

	int get = 0;
	for (int c = 0; input[c] != '\0'; c++) {
		switch (input[c]) {
		case '|':
			break;
		case '>':
			bottomp++;
			break;
		case '<':
			bottomp--;
			break;
		case '+':
			(*bottomp)++;
			break;
		case '!':
			*bottomp = 0;
			break;
		case '%':
			*bottomp += 50;
			break;
		case '*':
			*bottomp += 5;
			break;
		case 'd':
			topp++;
			break;
		case 'a':
			topp--;
			break;
		case '^':
			*topp = *bottomp;
			break;
		case '$':
			c = labels[(*topp)];
			break;
		case '?':
			if (*(topp + 1) == *(topp + 2)) {
				c = labels[(*topp)];
			}

			break;
		case 'v':
			*bottomp = *topp;
			break;
		case '-':
			(*bottomp)--;
			break;
		case '.':
			#ifdef EMULATOR_WINDOW
				// Manage standard OUT instructions, for graphics.
				switch (*topp) {
				case 50: // SETMODE
					// We don't have to do anything since
					// windowed mode is preset and precompiled
					break;
				case 51: // SETPIXEL
					gfx_setColor(&window, *(topp + 2), *(topp + 2), *(topp + 2));
					gfx_pixel(&window, *(topp + 1) % 320, *(topp + 1) / 320);
					break;
				}
			#else
				putchar(*bottomp);
			#endif	
			break;
		case ',':
			if (keys != NULL) {
				// Don't allow characters after null terminator to be
				// read
				if (get != 0 && keys[get - 1] == '\0') {
					puts("Read outside input, stopping\n");
					goto endAll;
				}

				*bottomp = keys[get];
				get++;

				continue;
			}
			
			#ifdef EMULATOR_WINDOW
				ia = gfx_event();
				while (ia.type != KEY) {
					ia = gfx_event(&window);
				}

				*bottomp = ia.value;
			#else
				// Switch between regular and raw input modes.
				system("/bin/stty raw");
				*bottomp = getchar();
				putchar(8); // Literally print backspace, delete the char
				system("/bin/stty cooked");

				// ESC kill.
				if (*bottomp == 27) {
					goto endAll;
				}
			#endif
			break;

		// Debug char
		case '#':
			puts("\nHalting program.");
			puts("Dumping 100 memory cells from bottom...");
			for (int i = 0; i < 200; i++) {
				printf("%d:\t%d\t%c\n", i, membottom[i], membottom[i]);
			}

			printf("Currently at memory position: %d\n", (int)(bottomp - membottom));

			goto endAll;
		}
	}

	endAll:

	// Handle end of window event
	#ifdef EMULATOR_WINDOW
		puts("Program finished. Press Q to exit.");
		while (1) {
			ia = gfx_event(&window);
			if (ia.type == KEY && ia.value == 'q') {
				break;
			}
		}
	#endif

	free(membottom);
	free(memtop);
	free(labels);
	free(input);
	putchar('\n');
	return 0;
}
