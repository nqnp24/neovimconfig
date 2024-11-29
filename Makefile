# Set the default compiler
CC = clang-18

# The CFLAGS variable sets compile flags for gcc:
# -g		compile with debug information
# -Wall		give verbose compiler warnings
# -O0		do not optimize generated code
# -std=c99	use the C99 standard language definition
CFLAGS = -std=c99 -Wall -g -O0

# The LDFLAGS variable sets flags for linker
# LDFLAGS =

# Files of the project
SOURCES = main.c
OBJECTS = $(SOURCES:.c=.o)
TARGET = test

$(TARGET): $(OBJECTS)
	$(CC) $(CFLAGS) -o $@ $^ #$(LDFLAGS)
	@echo "----------------------------------------"

# Phony means not a "real" target, it doesn't build anything
# The phony target "clean" is used to remove all compiled object files.
# 'core' is the name of the file outputted in some cases when you get a
# crash (SEGFAULT) with a "core dump"; it can contain more information about
# the crash.
.PHONY: clean

clean:
	rm -f $(TARGET) $(OBJECTS) core
