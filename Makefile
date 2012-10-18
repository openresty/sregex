CC=gcc
CFLAGS = -fpic -g -Wall -Werror -O -Isrc
pwd = $(shell pwd)

LIB_C_FILES = \
        src/sre_palloc.c \
        src/sre_regex.c \
        src/sre_regex_parser.c \
        src/sre_regex_compiler.c \
        src/sre_vm_bytecode.c \
        src/sre_vm_thompson.c

LIB_O_FILES = $(patsubst %.c,%.o,$(LIB_C_FILES))
H_FILES=$(wildcard src/*.h)

.PHONY: all clean
.PRECIOUS: src/sre_regex_parser.c

all: libsregex.so libsregex.a sregex

sregex: src/sregex.o libsregex.so
	$(CC) -o $@ -Wl,-rpath,$(pwd) $< -L. -lsregex

libsregex.so: $(LIB_O_FILES)
	$(CC) -shared -Wl,-soname,$@ -o $@ $+

libsregex.a: $(LIB_O_FILES)
	ar -cq $@ $(LIB_O_FILES)

%.o: %.c $(H_FILES)
	$(CC) -c $(CFLAGS) -o $@ $<

src/%.c: src/%.y
	bison -o $@ -v $<

clean:
	rm -f src/*.o core $(TARGET) src/sre_regex_parser.c \
	    src/*.output sregex *.so *.a

