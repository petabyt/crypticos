#include "header.h"

char *regs[] = {"ga", "gb", "gc", "gd"};

// Generate label name from number.
// Up to 2^27 labels. (134,217,728)
void generateLabel(size_t label, char buffer[]) {
	buffer[0] = 'a';
	buffer[1] = 'a';
	while (label != 0) {
		if (buffer[1] == 'z') {
			buffer[0]++;
			buffer[1] = 'a';
			continue;
		}

		buffer[1]++;
		label--;
	}

	buffer[2] = '\0';
}

int main(int argc, char *argv[]) {
	if (argc == 1) {puts("No file."); return 1;}
	FILE *reader = fopen(argv[1], "r");
	if (reader == NULL) {puts("Bad file."); return 1;}

	// Load 
	char *load = malloc(1000 * sizeof(char));
	size_t index = 0;
	int ch;
	while (1) {
		ch = fgetc(reader);
		if (ch == EOF) {
			load[index] = '\0';
			break;
		} else {
			load[index] = ch;
			index++;
		}
	}
	
	fclose(reader);
	
	size_t c = 0;
	struct Token tokens[10];
	size_t token = 0;

	// Insert assembly at end of blocks
	int block = -1;
	char blockStack[10][50];

	// Generate a new label from this:
	size_t currentLabel = 0;
	
	while (1) {
		int result = parse(&c, tokens, &token, load);
		if (result == PARSE_EOF) {
			break;
		}

		size_t currentReg = 0;
		
		for (size_t i = 0; i < token; i++) {
			switch (tokens[i].type) {
			case INTEGER:
				printf("set %s %d\n", regs[currentReg], tokens[i].value);
				currentReg++;
				break;
			case TEXT:
				printf("set %s %s\n", regs[currentReg], tokens[i].string);
				currentReg++;
				break;
			case ADD:
				puts("run add");
				currentReg = 0;
				break;
			case FUNCTION:
				printf("run %s\n", tokens[i].string);
				break;
			case EQUAL:
				i++;
				printf("set %s ga\n", tokens[i].string);
				break;
			}
		}

		// Parse Block statements
		if (result == PARSE_END) {			
			printf("%s\n", blockStack[block]);
			block--;
		} else if (result == PARSE_NEQU) {
			block++;
			generateLabel(currentLabel, blockStack[block]);
			printf("equ ga gb %s\n", blockStack[block]);

			// Push the label
			strcat(blockStack[block], ":");
			currentLabel++;
		} else if (result == PARSE_LOOP) {
			char l[4];
			block++;
			generateLabel(currentLabel, l);
			printf("%s:\n", l);

			// Push the label
			strcpy(blockStack[block], "jmp ");
			strcat(blockStack[block], l);
			currentLabel++;
		} else if (result == PARSE_EQU) {
			char l1[4];
			char l2[4];
			generateLabel(currentLabel, l1);
			currentLabel++;
			generateLabel(currentLabel, l2);
			currentLabel++;

			printf("equ ga gb %s\n", l2);
			printf("jmp %s\n", l1);
			printf("%s:\n", l2);

			// Push a the label
			block++;
			strcpy(blockStack[block], l1);
			strcat(blockStack[block], ":");
		}
	}

	free(load);
}
