INCLUDE?=$(shell echo ~/Documents/crypticos)/

CC=gcc
CFLAGS=-Wall -DCASM_LOCATION='"$(INCLUDE)"'

casm:
	$(CC) src/*.c $(CFLAGS) -o casm

casmw:
	$(CC) src/*.c $(CFLAGS) -o casmw -lX11 -D EMULATOR_WINDOW

/bin/casm: casm
	sudo cp casm /bin/casm

micro-syntax:
	mv casm.yaml ~/.config/micro/syntax/casm.yaml
