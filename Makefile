# Specify shell to execute recipes
SHELL=/bin/bash

# Set compilation options (these for for both gcc and clang):
#
# -Og optimizes for debugging purposes
# -ggdb3 adds extra debug info
# Optional: -m64 targets 64-bit architecture (unnecessary nowadays)
# -std=c99 uses C99 Standard features
# -Wall shows "all" warnings
# -Wextra show all other warnings
# -Werror treats all warnings as errors
# -pedantic checks for conformity to ANSI C

OS=$(shell echo `uname`)

# macOS gcc is symlinked to Xcode clang
# There are extra environment variables that need to be set for Homebrew clang
# to work, see https://stackoverflow.com/a/68183992
ifeq ($(OS),Darwin)
	ifeq ($(CLANG),1)
	CC=clang-17
	else
	CC=gcc-13
	endif
else
	ifeq ($(CLANG),1)
	CC=clang
	else
	CC=gcc
	endif
endif

# Windows (Cygwin) calls shared libraries DLLs
ifneq ($(findstring CYGWIN,$(OS)),)
LIBNAME=libfraction.dll
else ifneq ($(findstring Darwin,$(OS)),)
LIBNAME=libfraction.dylib
else # Linux
LIBNAME=libfraction.so
endif

# Compilation flags for executables and shared libraries
CFLAGS=-std=c99 -Wall -Wextra -Werror -pedantic
CFLAGS_LIB=-shared -fpic

# Debug flags
ifeq ($(DEBUG),1)
CFLAGS+=-Og -ggdb3
endif

# Compiles everything in the executable
normal: fraction.o frac_tester.o
	$(CC) $(CFLAGS) -o driver driver.c fraction.o frac_tester.o

# Compiles the executable with the shared library
lib: libfraction frac_tester_lib.o
	$(CC) $(CFLAGS) -o driver driver.c ./$(LIBNAME) frac_tester.o

# Compiles the executable and the shared library separately
# The shared library is linked at runtime
dl: libfraction
	$(CC) $(CFLAGS) -o driverdl driverdl.c

frac_tester.o: fraction.o frac_tester.c frac_tester.h
	$(CC) $(CFLAGS) -c frac_tester.c

frac_tester_lib.o: libfraction frac_tester.c frac_tester.h
	$(CC) $(CFLAGS) -c frac_tester.c

fraction.o: fraction.c fraction.h
	$(CC) $(CFLAGS) -c fraction.c

libfraction: fraction.c fraction.h
	$(CC) $(CFLAGS) $(CFLAGS_LIB) -o $(LIBNAME) fraction.c

clean:
	rm -rf *.o *.so *.dylib driver driverdl driver.dSYM *.exe *.dll

help:
	@echo "For debug build, run: make DEBUG=1. To use clang, run: make CLANG=1."

.PHONY: normal lib dl clean help
