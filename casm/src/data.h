#ifndef __DATA
#define __DATA

// What to replace '$' with at start of file names
#ifndef CASM_LOCATION
	#define CASM_LOCATION "/home/dan/Documents/crypticos/"
#endif

extern char *casmLocationS;

// Emulator sizes to allocate
// Will allocate ~120kb memory.
#define MAX_TOP 100
#define MAX_BOTTOM 10000
#define MAX_INPUT 100000
#define MAX_LABELS 10000

// Max memory objects (labels, vars, arrs)
#define MAX_MEMOBJ 500

#endif
