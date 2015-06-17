# Copyright (C) 2013 Yichun Zhang (agentzh)
# Copyright (C) 2005-2012 Mike Pall.

MAJVER=  0
MINVER=  0
RELVER=  1
VERSION= $(MAJVER).$(MINVER).$(RELVER)

FILE_T= sregex-cli
FILE_A= libsregex.a
FILE_SO= libsregex.so

CC= gcc
CFLAGS+= -fpic -g -Wall -O3 -Isrc -I.
PREFIX= /usr/local
DESTDIR=
INSTALL_X= install -m 0755
INSTALL_F= install -m 0644
MKDIR= mkdir -p
RMDIR= rmdir 2>/dev/null
UNINSTALL= $(HOST_RM)
HOST_RM= rm -f
LDCONFIG= ldconfig -n
SYMLINK= ln -sf
LUA= luajit
DASM= $(LUA) dynasm/dynasm.lua
DASM_FLAGS=

INSTALL_INC= $(DESTDIR)$(PREFIX)/include/sregex
INSTALL_LIB= $(DESTDIR)$(PREFIX)/lib
INSTALL_BIN= $(DESTDIR)$(PREFIX)/bin

INSTALL_ANAME= libsregex.a
INSTALL_SONAME= libsregex.so.$(MAJVER).$(MINVER).$(RELVER)
INSTALL_SOSHORT1= libsregex.so
INSTALL_SOSHORT2= libsregex.so.$(MAJVER)

ifeq (Darwin,$(shell uname -s))
    INSTALL_SONAME= libsregex.$(MAJVER).$(MINVER).$(RELVER).dylib
    INSTALL_SOSHORT1= libsregex.dylib
    INSTALL_SOSHORT2= libsregex.$(MAJVER).dylib
endif

INSTALL_T= $(INSTALL_BIN)/$(FILE_T)

INSTALL_STATIC= $(INSTALL_LIB)/$(INSTALL_ANAME)
INSTALL_DYN= $(INSTALL_LIB)/$(INSTALL_SONAME)
INSTALL_SHORT1= $(INSTALL_LIB)/$(INSTALL_SOSHORT1)
INSTALL_SHORT2= $(INSTALL_LIB)/$(INSTALL_SOSHORT2)

INSTALL_DIRS= $(INSTALL_INC) $(INSTALL_LIB) $(INSTALL_BIN)

TARGET_SONAME= libsregex.so.$(MAJVER)

ifeq (Darwin,$(shell uname -s))
  TARGET_SONAME= libsregex.$(MAJVER).dylib
  LDCONFIG= :
else
  ifeq (SunOS,$(shell uname -s))
    INSTALL_X=cp -p
    INSTALL_F=cp -p
  endif
endif

TARGET_DYLIBPATH= $(PREFIX)/lib/$(TARGET_SONAME)
TARGET_XSHLDFLAGS= -shared -fpic -Wl,-soname,$(TARGET_SONAME)
TARGET_AR=ar rcus
HOST_SYS:= $(shell uname -s)

ifeq (Darwin,$(HOST_SYS))
  FILE_SO= libsregex.dylib
  TARGET_XSHLDFLAGS= -dynamiclib -single_module -undefined dynamic_lookup -fpic
  TARGET_XSHLDFLAGS+= -install_name $(TARGET_DYLIBPATH) -compatibility_version $(MAJVER).$(MINVER) -current_version $(MAJVER).$(MINVER).$(RELVER)
endif

jobs= 1

ifeq ($(use_valgrind), 1)
    CFLAGS += -DSRE_USE_VALGRIND=1
endif

Q= @
E= @echo

pwd = $(shell pwd)

lib_c_files= \
   src/sregex/sre_palloc.c \
   src/sregex/sre_regex.c \
   src/sregex/sre_yyparser.c \
   src/sregex/sre_regex_compiler.c \
   src/sregex/sre_vm_bytecode.c \
   src/sregex/sre_vm_thompson.c \
   src/sregex/sre_vm_pike.c \
   src/sregex/sre_capture.c \
   src/sregex/sre_vm_thompson_jit.c

lib_o_files= $(patsubst %.c,%.o,$(lib_c_files))

h_files= src/sregex/sre_capture.h \
	 src/sregex/sre_palloc.h \
	 src/sregex/sre_vm_bytecode.h \
	 src/sregex/sre_yyparser.h \
	 src/sregex/sre_core.h \
	 src/sregex/sre_regex.h \
	 src/sregex/sre_vm_thompson_x64.h \
	 src/sregex/sre_vm_thompson.h \
	 src/sregex/sregex.h \

plist_vfiles= $(patsubst src/sregex/%.c,%.plist,$(lib_c_files))

INSTALL_H_FILES= src/sregex/sregex.h src/sregex/ddebug.h

.PHONY: all clean distclean test val install uninstall
.PRECIOUS: \
    src/sregex/sre_yyparser.c \
    src/sregex/sre_yyparser.h \
    src/sregex/sre_vm_thompson_x64.h

all: $(FILE_SO) $(FILE_A) $(FILE_T)

$(FILE_T): src/sre_cli.o $(lib_o_files)
	$(E) "LINK      $@"
	$(Q)$(CC) -o $@ $+

$(FILE_SO): $(lib_o_files)
	$(E) "DYNLINK   $@"
	$(Q)$(CC) $(TARGET_XSHLDFLAGS) -o $@ $+
	$(E) "SYMLINK   $(INSTALL_SOSHORT2)"
	$(Q)$(SYMLINK) $@ $(INSTALL_SOSHORT2)

$(FILE_A): $(lib_o_files)
	$(E) "AR        $@"
	$(Q)$(TARGET_AR) $@ $(lib_o_files)

%.o: %.c $(h_files)
	$(E) "CC        $@"
	$(Q)$(CC) $(CFLAGS) -c -o $@ $<

%.c %.h: %.y
	$(E) "BISON     $@"
	$(Q)bison -p sregex_yy -v $<
	$(Q)./util/fix-bison-comments

%.h: %.dasc
	$(E) "DYNASM    $@"
	$(Q)$(DASM) $(DASM_FLAGS) -o $@ $<

clean:
	$(HOST_RM) *.dylib *.so *.so.* src/*.o $(lib_o_files) core $(TARGET) \
		src/sregex/*.output \
		$(FILE_T) $(FILE_SO) $(FILE_A)

distclean: clean
	$(HOST_RM) src/sregex/sre_yyparser.[ch]

test: all
	prove -j$(jobs) -r t

val:
	$(MAKE) use_valgrind=1 all -B -j$(jobs)

valtest: val
	TEST_SREGEX_USE_VALGRIND=1 prove -j$(jobs) -r t
	$(MAKE) -B -j$(jobs)

clang: $(plist_vfiles)

%.plist: src/sregex/%.c $(h_files)
	@echo $<
	-@clang -O --analyze -Wextra -Wall -Werror -Isrc -I. $<

install: all
	@echo "==== Installing sregex $(VERSION) to $(PREFIX) ===="
	$(MKDIR) $(INSTALL_DIRS)
	$(INSTALL_X) $(FILE_T) $(INSTALL_T)
	$(INSTALL_F) $(INSTALL_H_FILES) $(INSTALL_INC)
	$(INSTALL_X) $(FILE_SO) $(INSTALL_DYN)
	-$(LDCONFIG) $(INSTALL_LIB)
	$(SYMLINK) $(INSTALL_SONAME) $(INSTALL_SHORT1)
	-$(SYMLINK) $(INSTALL_SONAME) $(INSTALL_SHORT2)
	@echo "==== Successfully installed sregex $(VERSION) to $(PREFIX) ===="

uninstall:
	@echo "==== Uninstalling sregex $(VERSION) to $(PREFIX) ===="
	$(UNINSTALL) $(INSTALL_T)
	$(UNINSTALL) $(INSTALL_LIB)/$(FILE_SO)
	$(UNINSTALL) $(INSTALL_LIB)/libsregex.a
	$(UNINSTALL) $(INSTALL_SHORT1)
	$(UNINSTALL) $(INSTALL_SHORT2)

	for file in $(patsubst src/sregex/%,%,$(INSTALL_H_FILES)); do \
	    $(UNINSTALL) $(INSTALL_INC)/$$file; \
	done
	$(RMDIR) $(INSTALL_INC)
	@echo "==== Successfully uninstalled sregex $(VERSION) from $(PREFIX) ===="

