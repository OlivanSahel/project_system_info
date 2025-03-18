GRM=C.y
LEX=an_lex_V2.l
BIN=./C
TEST=test.c

CC=gcc
CFLAGS=-Wall -g

OBJ=y.tab.o lex.yy.o

all: $(BIN)

%.o: %.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

y.tab.c: $(GRM)
	yacc -t -v -g -d $<

lex.yy.c: $(LEX)
	flex $<

$(BIN): $(OBJ)
	$(CC) $(CFLAGS) $(CPPFLAGS) $^ -o $@

clean:
	rm -f $(OBJ) y.tab.c y.tab.h lex.yy.c

run: $(BIN)
	cat $(TEST) | $(BIN)

