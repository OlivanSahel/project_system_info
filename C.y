%{
#include <stdlib.h>
#include <stdio.h>
int var[26];
void yyerror(char *s);
int yylex();
%}

%union {  
  int nb; 
  char* var; 
}

%token tCOMP tEQ tBT tLT tSUB tADD tMUL tDQUOTE tQUOTE tDIV tMODULO tOP tCP tIF tELSE tWHILE tPOINT tSHARP tINT tCHAR tFLOAT tSTRING tOB tCB tCOMA tSEMICOL tNULL 
%token tAND tOR tRETURN tPRINT tFL tERROR tGE tLE tNE
%token <nb> tNB
%token <var> tID
%left tADD
%left tMUL
%start C
%%

C: /* epsilon */
  | C FUNCTION
  ;

TYPE :  tINT 
      | tCHAR
      | tSTRING
      | tFLOAT
      ;


BODY: tOB INBODY tCB   

INBODY : | INSTRUCTION INBODY ;

INSTRUCTION :
          DECLARATION 
        | IF
        | WHILE
        | AFFECTATION
        ;

FUNCTION: TYPE tID tOP ARGUMENTS tCP BODY  

ARGUMENTS: TYPE tID                 
          | TYPE tID tCOMA ARGUMENTS  
          ;

DECLARATION : TYPE tID tEQ CALC tSEMICOL
            | TYPE tID tSEMICOL
            ;

AFFECTATION : tID tEQ CALC tSEMICOL
            ;

IF : tIF tOP CALC tCP BODY       
    |tIF tOP CALC tCP BODY tELSE BODY
   ;

WHILE : tWHILE tOP CALC tCP BODY      
   ;
          ;

STRING: tDQUOTE tID tDQUOTE ;

CALC :  tID
      | tNB
      | CALC tADD CALC
      | CALC tMUL CALC
      ;


%%
void yyerror(char *s) { fprintf(stderr, "%s\n", s); }
int main(void) {
  yyparse();
  return 0;
}
