# Specify shell to execute recipes
SHELL=/bin/bash

# Set compilation options:
#
# -O0 no optimizations; remove after debugging
# -m64 target 64-bit architecture
# -std=c99 use C99 Standard features
# -Wall show "all" warnings
# -W show even more warnings (annoyingly informative)
# -ggdb3 add extra debug info; remove after debugging

CC=gcc
CFLAGS=-O0 -m64 -std=c99 -Wall -W -ggdb3

driver: Fraction.o FracTester.o
	$(CC) $(CFLAGS) -o driver driver.c Fraction.o FracTester.o

FracTester.o: Fraction.o FracTester.c FracTester.h
	$(CC) $(CFLAGS) -c FracTester.c

Fraction.o: Fraction.c Fraction.h
	$(CC) $(CFLAGS) -c Fraction.c

clean:
	rm -f *.o
