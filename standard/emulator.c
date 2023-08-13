// This is a simple terminal-based emulator for CINS.

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
	char input[] = "!*********+++>|<.+>dd!<^>a!%*++^a!+^!?!^$|";
	
	int memtop[50] = {0};
	int membottom[1000] = {0};
	size_t topp = 0;
	size_t bottomp = 0;
	
	// Map the labels in an array.
	int labels[50];
	int l = 0;
	for (int c = 0; input[c] != '\0'; c++) {
		if (input[c] == '|') {
			labels[l] = c;
			l++;
		}
	}

	for (int c = 0; input[c] != '\0'; c++) {
		switch (input[c]) {
		case ',':
			membottom[bottomp] = getchar();
			break;
		case '!':
			membottom[bottomp] = 0;
			break;
		case '%':
			membottom[bottomp] += 50;
			break;
		case '*':
			membottom[bottomp] += 5;
			break;
		case '+':
			membottom[bottomp]++;
			break;
		case '-':
			membottom[bottomp]--;
			break;
		case '.':
			putchar(membottom[bottomp]);
			break;
		case '>':
			bottomp++;
			break;
		case '<':
			bottomp--;
			break;
		case 'd':
			topp++;
			break;
		case 'a':
			topp--;
			break;
		case '^':
			memtop[topp] = membottom[bottomp];
			break;
		case 'v':
			membottom[bottomp] = memtop[topp];
			break;
		case '$':
			c = labels[memtop[topp]];
			break;
		case '?':
			if (memtop[topp + 1] == memtop[topp + 2]) {
				c = labels[memtop[topp]];
			}

			break;
		}
	}

	putchar('\n');

	return 0;
}
