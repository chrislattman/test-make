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

ifeq ($(OS),Darwin)
	GCOV=gcov-13
else
	GCOV=gcov
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
	ifeq ($(CLANG),1)
	CFLAGS+=-Og -glldb -g3
	else
	CFLAGS+=-Og -ggdb -g3
	endif
endif

# ASan flags
ifeq ($(CLANG),1)
ASAN_FLAGS=-fsanitize=address -O1 -g -fno-optimize-sibling-calls -fno-omit-frame-pointer -fsanitize-address-use-after-scope
else
ASAN_FLAGS=-fsanitize=address -O1 -g -fno-optimize-sibling-calls
endif

# LSan flags
LSAN_FLAGS=-fsanitize=leak

# MSan flags (only supported on clang)
ifeq ($(CLANG),1)
MSAN_FLAGS=-fsanitize=memory -O1 -fno-omit-frame-pointer -fno-optimize-sibling-calls
endif

# TSan flags
TSAN_FLAGS=-fsanitize=thread -O1 -g

# UBSan flags
ifeq ($(CLANG),1)
UBSAN_FLAGS=-fsanitize=undefined -fsanitize=float-divide-by-zero -fsanitize=unsigned-integer-overflow -fsanitize=implicit-conversion -fsanitize=local-bounds -fsanitize=nullability
else
UBSAN_FLAGS=-fsanitize=undefined -fsanitize=float-divide-by-zero -fsanitize=float-cast-overflow
endif

# Coverage flags
ifeq ($(CLANG),1)
COV_FLAGS=-fprofile-instr-generate -fcoverage-mapping
else
COV_FLAGS=--coverage
endif

# Compiles everything in the executable
normal: frac_tester.o
	$(CC) $(CFLAGS) -o driver driver.c fraction.o frac_tester.o

# Sanitizers should be run separately (therefore not stored as an environment variable)

# AddressSanitizer
asan: frac_tester_asan
	$(CC) $(CFLAGS) $(ASAN_FLAGS) -o driver driver.c fraction.o frac_tester.o

# LeakSanitizer
lsan: frac_tester_lsan
	$(CC) $(CFLAGS) $(LSAN_FLAGS) -o driver driver.c fraction.o frac_tester.o

# MemorySanitizer
msan: frac_tester_msan
	$(CC) $(CFLAGS) $(MSAN_FLAGS) -o driver driver.c fraction.o frac_tester.o

# ThreadSanitizer
tsan: frac_tester_tsan
	$(CC) $(CFLAGS) $(TSAN_FLAGS) -o driver driver.c fraction.o frac_tester.o

# UndefinedBehaviorSanitizer
ubsan: frac_tester_ubsan
	$(CC) $(CFLAGS) $(UBSAN_FLAGS) -o driver driver.c fraction.o frac_tester.o

# Instruments executable for code coverage
coverage: frac_tester_cov
	$(CC) $(CFLAGS) $(COV_FLAGS) -o driver driver.c fraction.o frac_tester.o
ifneq ($(CLANG),1)
	mv driver-driver.gcno driver.gcno
endif

# Generates HTML report after running instrumented executable (has issues on macOS)
# An alternative to gcov->lcov->genhtml is gcovr
report: driver.c fraction.c frac_tester.c
ifeq ($(CLANG),1)
	llvm-profdata merge --sparse -o default.profdata default.profraw
	llvm-cov show -format=html -output-dir=out -instr-profile=default.profdata ./driver
else
	mv driver-driver.gcda driver.gcda
	$(GCOV) driver.c fraction.c frac_tester.c
	lcov --capture --directory . --output-file coverage.info
	genhtml coverage.info --output-directory out
endif

# Compiles the executable with the shared library
lib: frac_tester_lib.o
	$(CC) $(CFLAGS) -o driver driver.c ./$(LIBNAME) frac_tester.o

frac_tester_lib.o: libfraction frac_tester.c frac_tester.h
	$(CC) $(CFLAGS) -c frac_tester.c

# Compiles the executable and the shared library separately
# The shared library is linked at runtime
dl: libfraction
	$(CC) $(CFLAGS) -o driverdl driverdl.c

frac_tester.o: fraction.o frac_tester.c frac_tester.h
	$(CC) $(CFLAGS) -c frac_tester.c

libfraction: fraction.c fraction.h
	$(CC) $(CFLAGS) $(CFLAGS_LIB) -o $(LIBNAME) fraction.c

fraction.o: fraction.c fraction.h
	$(CC) $(CFLAGS) -c fraction.c

frac_tester_asan: fraction_asan frac_tester.c frac_tester.h
	$(CC) $(CFLAGS) $(ASAN_FLAGS) -c frac_tester.c

frac_tester_lsan: fraction_lsan frac_tester.c frac_tester.h
	$(CC) $(CFLAGS) $(LSAN_FLAGS) -c frac_tester.c

frac_tester_msan: fraction_msan frac_tester.c frac_tester.h
	$(CC) $(CFLAGS) $(MSAN_FLAGS) -c frac_tester.c

frac_tester_tsan: fraction_tsan frac_tester.c frac_tester.h
	$(CC) $(CFLAGS) $(TSAN_FLAGS) -c frac_tester.c

frac_tester_ubsan: fraction_ubsan frac_tester.c frac_tester.h
	$(CC) $(CFLAGS) $(UBSAN_FLAGS) -c frac_tester.c

frac_tester_cov: fraction_cov frac_tester.c frac_tester.h
	$(CC) $(CFLAGS) $(COV_FLAGS) -c frac_tester.c

fraction_asan: fraction.c fraction.h
	$(CC) $(CFLAGS) $(ASAN_FLAGS) -c fraction.c

fraction_lsan: fraction.c fraction.h
	$(CC) $(CFLAGS) $(LSAN_FLAGS) -c fraction.c

fraction_msan: fraction.c fraction.h
	$(CC) $(CFLAGS) $(MSAN_FLAGS) -c fraction.c

fraction_tsan: fraction.c fraction.h
	$(CC) $(CFLAGS) $(TSAN_FLAGS) -c fraction.c

fraction_ubsan: fraction.c fraction.h
	$(CC) $(CFLAGS) $(UBSAN_FLAGS) -c fraction.c

fraction_cov: fraction.c fraction.h
	$(CC) $(CFLAGS) $(COV_FLAGS) -c fraction.c

clean:
	rm -rf *.o *.so *.dylib driver driverdl driver.dSYM *.exe *.dll *.gcno *.gcda *.gcov *.info out *.prof*

help:
	@echo "For debug build, run: make DEBUG=1. To use clang, run: make CLANG=1."

.PHONY: normal lib dl clean help
