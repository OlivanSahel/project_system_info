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
%left tADD tSUB
%left tMUL tDIV
%start C
%%

C: %empty/* epsilon */
  | C FUNCTION
  ;

TYPE :  tINT 
      | tCHAR
      | tSTRING
      | tFLOAT
      ;


BODY: tOB INBODY tCB   

INBODY : | INSTRUCTION INBODY 
         | RETURN 
         ;

INSTRUCTION :
          DECLARATION 
        | IF
        | WHILE
        | AFFECTATION
        | PRINT
        ;

FUNCTION: TYPE tID tOP ARGUMENTS tCP BODY  ;

PRINT: tPRINT tOP CALC tCP tSEMICOL
      ;

ARGUMENTS: 
          | TYPE tID                 
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

CALC :  NUMBRE
      | CALC tADD NUMBRE
      | CALC tMUL NUMBRE
      | CALC tDIV NUMBRE
      | CALC tSUB NUMBRE
      | tOP CALC tCP
      ;

NUMBRE: tID 
      | tNB

RETURN : tRETURN CALC tSEMICOL
        ;

%%
extern int yylineno;

void yyerror(char *msg) {
    fprintf(stderr, "error: '%s' at line %d.\n", msg, yylineno);
    exit(1);
}

int main(void) {
  yyparse();
  printf("compilation réussie :) \n");
  return 0;
}
