# Specify shell to execute recipes
SHELL=/bin/bash

# Set compilation options:
#
# -O0 no optimizations, for debugging purposes
# -ggdb3 adds extra debug info
# -m64 targets 64-bit architecture
# -std=c99 uses C99 Standard features
# -Wall shows "all" warnings
# -Wextra show all other warnings
# -Werror treats all warnings as errors
# -pedantic checks for conformity to ANSI C

# macOS gcc is symlinked to clang
ifeq ($(shell echo `uname`),Darwin)
CC=gcc-12
else
CC=gcc
endif

CFLAGS_DEBUG=-O0 -ggdb3
CFLAGS=-m64 -std=c99 -Wall -Wextra -Werror -pedantic
CFLAGS_SO=-shared -fpic

release: fraction.o frac_tester.o
	$(CC) $(CFLAGS) -o driver driver.c fraction.o frac_tester.o

debug: fraction.o frac_tester.o
	$(CC) $(CFLAGS) $(CFLAGS_DEBUG) -o driver driver.c fraction.o frac_tester.o

lib: libfraction.so frac_tester_lib.o
	$(CC) $(CFLAGS) -o driver driver.c ./libfraction.so frac_tester.o

libdebug: libfraction.so frac_tester_lib.o
	$(CC) $(CFLAGS) $(CFLAGS_DEBUG) -o driver driver.c ./libfraction.so frac_tester.o

dl: libfraction.so
	$(CC) $(CFLAGS) -o driver driverdl.c

dldebug: libfraction.so
	$(CC) $(CFLAGS) $(CFLAGS_DEBUG) -o driver driverdl.c

frac_tester.o: fraction.o frac_tester.c frac_tester.h
	$(CC) $(CFLAGS) -c frac_tester.c

frac_tester_lib.o: libfraction.so frac_tester.c frac_tester.h
	$(CC) $(CFLAGS) -c frac_tester.c

fraction.o: fraction.c fraction.h
	$(CC) $(CFLAGS) -c fraction.c

libfraction.so: fraction.c fraction.h
	$(CC) $(CFLAGS) $(CFLAGS_SO) -o libfraction.so fraction.c

clean:
	rm -rf *.o *.so driver driver.dSYM

.PHONY: release debug lib lib_debug clean
