%{
#define YY_NO_INPUT
#include <stdlib.h>
#include <stdio.h>
#include "y.tab.h"
%}

%option noyywrap
%option yylineno

%%

"//".*                  { /* Skip comments */ }
[\n \t]+                { /* Skip whitespace */ }
[0-9]+                  { yylval.nb = atoi(yytext); return tNB; }
"=="                    { return tCOMP; }
"!="                    { return tNE; }
"="                     { return tEQ; }
">"                     { return tBT; }
"<"                     { return tLT; }
"<="                    { return tLE; }
">="                    { return tGE; }
"-"                     { return tSUB; }
"+"                     { return tADD; }
"*"                     { return tMUL; }
"/"                     { return tDIV; }
"%"                     { return tMODULO; }
"("                     { return tOP; }
")"                     { return tCP; }
"if"                    { return tIF; }
"else"                  { return tELSE; }
"while"                 { return tWHILE; }
"int"                   { return tINT; }
"const"                 { return tCONST; }
"{"                     { return tOB; }
"}"                     { return tCB; }
","                     { return tCOMA; }
";"                     { return tSEMICOL; }
"&&"                   { return tAND; }
"||"                   { return tOR; }
"return"               { return tRETURN; }
"."                    { return tPOINT; }
"#"                    { return tSHARP; }
"print"                { return tPRINT; }
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.var = strdup(yytext); return tID; }
.                      { return tERROR; }

%%
