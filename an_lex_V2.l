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
"==" { return tCOMP; }
"!=" { return tNE; }
"="	{ return tEGAL; }
">" { return tBT; }
"<" { return tLT; }
"<=" { return tLE; }
">=" { return tGE; }
"-"	{ return tSUB; }
"+"	{ return tADD; }
"*"	{ return tMUL; }
"/"	{ return tFSLASH; }
"%" {return tMODULO; }
"("	{ return tOP; }
")"	{ return tCP; }
"if" { return tIF; }
"else" { return tELSE; }
"while" { return tWHILE; }
"int" { return tINT; }
"char" { return tCHAR; }
"string" { return tSTRING; }
"float" { return tFLOAT; }
"{" { return tOB; }
"}" { return tCB; }
"," { return tCOMA; }
";" { return tSEMICOL; }
"\"" { return tDQUOTE; }
"\'" {return tQUOTE; }
"NULL" { return tNULL; }
"&&" { return tAND;}
"||" { return tOR; }
"return" { return tRETURN; }
"." { return tPOINT}
"#" { return tSHARP}
"print" { return tPRINT; }
[a-zA-Z0-9_]+	{
	  yylval.var = strdup(yytext);
	  return tID;
	}
["(a-zA-Z0-9_)+"]	{
	  yylval.var = strdup(yytext)t;
	  return tACTUALSTRING;
	}

\n	{ return tFL; }
.	{ return tERROR; }

%%

void main(void){
    yylex();
}