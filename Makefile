# Specify shell to execute recipes
SHELL=/bin/bash

# Set compilation options:
#
# -O0 no optimizations; remove after debugging
# -m64 targets 64-bit architecture
# -std=c99 uses C99 Standard features
# -Wall shows "all" warnings
# -Wextra show all other warnings
# -Werror treats all warnings as errors
# -pedantic checks for conformity to ANSI C
# -ggdb3 adds extra debug info; remove after debugging

CC=gcc
CFLAGS=-O0 -m64 -std=c99 -Wall -Wextra -Werror -pedantic -ggdb3

all: Fraction.o FracTester.o
	$(CC) $(CFLAGS) -o driver driver.c Fraction.o FracTester.o

FracTester.o: Fraction.o FracTester.c FracTester.h
	$(CC) $(CFLAGS) -c FracTester.c

Fraction.o: Fraction.c Fraction.h
	$(CC) $(CFLAGS) -c Fraction.c

clean:
	rm -rf *.o driver driver.dSYM

.PHONY: all clean
