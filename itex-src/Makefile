#YACC=yacc
YACC=bison -y  -v
LEX=flex -P$(YYPREFIX) -olex.yy.c

RM=rm -f

YYPREFIX=itex2MML_yy

all:    y.tab.c lex.yy.c itex2MML

y.tab.c:	itex2MML.y
		$(YACC) -p $(YYPREFIX) -d itex2MML.y

lex.yy.c:	itex2MML.l
		$(LEX) itex2MML.l

y.tab.o:	y.tab.c itex2MML.h
		$(CC) $(CFLAGS) -c -o y.tab.o y.tab.c

lex.yy.o:	lex.yy.c y.tab.c itex2MML.h
		$(CC) $(CFLAGS) -c -o lex.yy.o lex.yy.c

itex2MML:	lex.yy.o y.tab.o itex2MML.cc itex2MML.h
		$(CXX) $(CFLAGS) -o itex2MML lex.yy.o y.tab.o itex2MML.cc
		$(RM) y.tab.* lex.yy.c *.o *.output

clean:
		$(RM) y.tab.* lex.yy.c *.o *.output itex2MML
