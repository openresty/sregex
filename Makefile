CC=gcc
CFLAGS = -fpic -g -Wall -Werror -O -Isrc
pwd = $(shell pwd)

lib_c_files = \
        src/sre_palloc.c \
        src/sre_regex.c \
        src/sre_regex_parser.c \
        src/sre_regex_compiler.c \
        src/sre_vm_bytecode.c \
        src/sre_vm_thompson.c \
        src/sre_vm_pike.c \
        src/sre_capture.c

lib_o_files = $(patsubst %.c,%.o,$(lib_c_files))
h_files=$(wildcard src/*.h)
plist_vfiles=$(patsubst src/%.c,%.plist,$(lib_c_files)) src/sregex.c

.PHONY: all clean test
.PRECIOUS: src/sre_regex_parser.c

all: libsregex.so libsregex.a sregex

sregex: src/sregex.o libsregex.so
	$(CC) -o $@ -Wl,-rpath,$(pwd) $< -L. -lsregex

libsregex.so: $(lib_o_files)
	$(CC) -shared -Wl,-soname,$@ -o $@ $+

libsregex.a: $(lib_o_files)
	rm -f $@
	ar -cq $@ $+

%.o: %.c $(h_files)
	$(CC) -c $(CFLAGS) -o $@ $<

src/%.c: src/%.y
	bison -o $@ -v $<

clean:
	rm -f src/*.o core $(TARGET) src/sre_regex_parser.c \
	    src/*.output sregex *.so *.a

test: all
	prove -r t

valtest: all
	TEST_SREGEX_USE_VALGRIND=1 prove -r t

clang: $(plist_vfiles)

%.plist: src/%.c
	@echo $<
	-@clang -O --analyze -Wextra -Wall -Werror -Isrc $<

