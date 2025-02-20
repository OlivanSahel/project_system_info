%{
#include <stdlib.h>
#include <stdio.h>
#include "y.tab.h"
%}

%option noyywrap

%%

[ \t]+	{};
[0-9]+	{
	  yylval.nb = atoi(yytext);
	  return tNB;
	}
"==" { return TCOMP; }
"!=" { return NE; }
"="	{ return tEGAL; }
">" { return tBT; }
"<" { return tLT; }
"<=" { return LE; }
">=" { return GE; }
"-"	{ return tSUB; }
"+"	{ return tADD; }
"*"	{ return tMUL; }
"/"	{ return tFSLASH; }
"("	{ return tOP; }
")"	{ return tCP; }
"if" { return tIF; }
"else" { return tELSE; }
"while" { return tWHILE; }
"int" { return tINT; }
"{" { return tOB; }
"}" { return tCB; }
"," { return tCOMA; }
";" { return tSEMICOL; }
"NULL" { return tNULL; }
"&&" { return tAND;}
"||" { return tOR; }
"return" { return tRETURN; }
"." { return tPOINT}
"#" { return tSHARP}
"print" { return tPRINT; }
[a-zA-Z0-9_]+	{
	  yylval.var = yytext[0];
	  return tID;
	}
\n	{ return tFL; }
.	{ return tERROR; }

%%

void main(void){
    yylex();
}