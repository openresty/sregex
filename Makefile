CC= gcc
CFLAGS+= -fpic -g -Wall -Werror -O -Isrc
PREFIX= /usr/local
DESTDIR=
INSTALL_X= install -m 0755
INSTALL_F= install -m 0644
INSTALL_INC= $(DESTDIR)$(PREFIX)/include/sregex
INSTALL_LIB= $(DESTDIR)$(PREFIX)/lib
INSTALL_BIN= $(DESTDIR)$(PREFIX)/bin
INSTALL_DIRS= $(INSTALL_INC) $(INSTALL_LIB) $(INSTALL_BIN)
MKDIR= mkdir -p
RMDIR= rmdir 2>/dev/null
RM= rm -f
UNINSTALL= $(RM)
jobs= 1

ifeq ($(use_valgrind), 1)
    CFLAGS += -DSRE_USE_VALGRIND=1
endif

pwd = $(shell pwd)

lib_c_files= \
   src/sregex/sre_palloc.c \
   src/sregex/sre_regex.c \
   src/sregex/sre_yyparser.c \
   src/sregex/sre_regex_compiler.c \
   src/sregex/sre_vm_bytecode.c \
   src/sregex/sre_vm_thompson.c \
   src/sregex/sre_vm_pike.c \
   src/sregex/sre_capture.c

lib_o_files= $(patsubst %.c,%.o,$(lib_c_files))
h_files= $(wildcard src/sregex/*.h)
plist_vfiles= $(patsubst src/sregex/%.c,%.plist,$(lib_c_files))

INSTALL_H_FILES= src/sregex/sregex.h src/sregex/ddebug.h

.PHONY: all clean test val install uninstall
.PRECIOUS: src/sre_regex_parser.c

all: libsregex.so libsregex.a sregex-cli

sregex-cli: src/sre_cli.o libsregex.so
	$(CC) -o $@ -Wl,-rpath,$(pwd) $< -L. -lsregex

libsregex.so: $(lib_o_files)
	$(CC) -shared -o $@ $+

libsregex.a: $(lib_o_files)
	rm -f $@
	ar -cq $@ $+

%.o: %.c $(h_files)
	$(CC) -c $(CFLAGS) -o $@ $<

%.c: %.y
	bison -v $<

clean:
	rm -f src/*.o core $(TARGET) src/sre_regex_parser.c \
	    src/*.output sregex-cli *.so *.a

test: all
	prove -j$(jobs) -r t

val:
	$(MAKE) use_valgrind=1 all -B -j$(jobs)

valtest: val
	TEST_SREGEX_USE_VALGRIND=1 prove -j$(jobs) -r t
	$(MAKE) -B -j$(jobs)

clang: $(plist_vfiles)

%.plist: src/sregex/%.c
	@echo $<
	-@clang -O --analyze -Wextra -Wall -Werror -Isrc $<

install: all
	@echo "==== install sregex to $(DESTDIR)$(PREFIX)/ ===="
	$(MKDIR) $(INSTALL_DIRS)
	$(INSTALL_F) $(INSTALL_H_FILES) $(INSTALL_INC)/
	$(INSTALL_F) libsregex.so libsregex.a $(INSTALL_LIB)/
	$(INSTALL_X) sregex-cli $(INSTALL_BIN)/

uninstall:
	@echo "==== Uninstall sregex from $(PREFIX)/ ===="
	$(UNINSTALL) $(INSTALL_BIN)/sregex-cli
	$(UNINSTALL) $(INSTALL_LIB)/libsregex.so
	$(UNINSTALL) $(INSTALL_LIB)/libsregex.a
	for file in $(patsubst src/sregex/%,%,$(INSTALL_H_FILES)); do \
	    $(UNINSTALL) $(INSTALL_INC)/$$file; \
	done
	$(RMDIR) $(INSTALL_INC)

