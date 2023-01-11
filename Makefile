# Specify shell to execute recipes
SHELL=/bin/bash

# To compile 

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

OS=$(shell echo `uname`)

# macOS gcc is symlinked to clang
ifeq ($(OS),Darwin)
CC=gcc-12
else
CC=gcc
endif

# Windows (Cygwin) calls shared libraries DLLs
# macOS normally uses .dylib for shared libraries, but
# we are not using clang, so .so will be used for macOS (and Linux)
ifneq ($(findstring CYGWIN,$(OS)),)
LIBNAME=libfraction.dll
else
LIBNAME=libfraction.so
endif

# Compilation flags for executables and shared libraries
CFLAGS=-m64 -std=c99 -Wall -Wextra -Werror -pedantic
CFLAGS_LIB=-shared -fpic

# Debug flags
ifeq ($(DEBUG),1)
CFLAGS+=-O0 -ggdb3
endif

normal: fraction.o frac_tester.o
	$(CC) $(CFLAGS) -o driver driver.c fraction.o frac_tester.o

lib: libfraction frac_tester_lib.o
	$(CC) $(CFLAGS) -o driver driver.c ./$(LIBNAME) frac_tester.o

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
	rm -rf *.o *.so driver driverdl driver.dSYM *.exe *.dll

help:
	@echo "For debug build, run: make DEBUG=1"

.PHONY: normal lib dl clean help
