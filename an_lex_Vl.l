%{
#include <stdlib.h>
#include <stdio.h>
%}

%option noyywrap

%%

[ \t]+	{};
[0-9]+	{
	   //yylval.nb = atoi(yytext);
	  printf( " tNB %d \n", atoi(yytext));
	}
"==" { printf( " TCOMP"); }
"="	{ printf( " tEGAL"); }
">" { printf( " tBT"); }
"<" { printf( " tLT"); }
"-"	{ printf( " tSOU"); }
"+"	{ printf( " tADD"); }
"*"	{ printf( " tMUL"); }
"/"	{ printf( " tFSLASH"); }
"("	{ printf( " tOP"); }
")"	{ printf( " tCP"); }
"if" { printf( " tIF"); }
"else" { printf( " tELSE"); }
"while" { printf( " tWHILE"); }
"int" { printf( " tINT"); }
"{" { printf( " tOB"); }
"}" { printf( " tCB"); }
"," { printf( " tCOMA"); }
";" { printf( " tSEMICOL"); }
"NULL" { printf( " tNULL"); }
"&&" { printf( " tAND");}
"||" { printf( " tOR"); }
"return(" { printf("tRETURN"); }
"print" { printf( " tPRINT"); }
[a-zA-Z0-9_]+	{
	 // yylval.var = yytext[0];
	  printf( " tID %s \n", yytext);
	}
\n	{ printf( " tFL"); }
.	{ printf( " tERROR"); }

%%

void main(void){
    yylex();
}