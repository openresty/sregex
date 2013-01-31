RE1_LIB=../../re1
RE1_INC=../../re1
PCRE_LIB=/opt/pcre832jit/lib
PCRE_INC=/opt/pcre832jit/include

CFLAGS= -c -Wall -Werror -O3 -g
REGEX1=
FILE1=abc.txt

.PHONY: all test

all: sregex re1 pcre

sregex: sregex.o ../libsregex.a
	$(CC) -o $@ -Wl,-rpath,.. -L.. $< -lsregex -lrt

re1: re1.o $(RE1_LIB)/libre1.a
	$(CC) -o $@ -Wl,-rpath,$(RE1_LIB) -L$(RE1_LIB) $< -lre1 -lrt

pcre: pcre.o
	$(CC) -o $@ -Wl,-rpath,$(PCRE_LIB) -L$(PCRE_LIB) $< -lpcre -lrt

%.o: %.c
	$(CC) $(CFLAGS) -I../src -I$(RE1_INC) -I$(PCRE_INC) $<

test: all $(FILE1)
	./bench '(?:a|b)aa(?:aa|bb)cc(?:a|b)' $(FILE1)

clean:
	rm -rf *.o sregex re1

$(FILE1):
	perl gen-data.pl

