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
%token tAND tOR tRETURN tPRINT tERROR tGE tLE tNE
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
      ;


BODY: tOB INBODY tCB   

INBODY : %empty
      | INSTRUCTION INBODY 
         | RETURN 
         ;

INSTRUCTION :
          DECLARATION { $$ = $1 }
        | IF { $$ = $1 }
        | WHILE { $$ = $1 }
        | AFFECTATION { $$ = $1 }
        | PRINT { $$ = $1 }
        ;

FUNCTION: TYPE tID tOP ARGUMENTS tCP BODY  ;

PRINT: tPRINT tOP CALC tCP tSEMICOL
      ;

ARGUMENTS: %empty
          | TYPE tID                 
          | TYPE tID tCOMA ARGUMENTS  
          ;

DECLARATION : TYPE tID tEQ CALC tSEMICOL { $1 $2 = $4 ; }
            | TYPE tID tSEMICOL { $1 $2 ; }
            ;

AFFECTATION : tID tEQ CALC tSEMICOL { $1 = $2 ; }
            ;

IF : tIF tOP CALC tCP BODY {if ( $3 ) $5}
    |tIF tOP CALC tCP BODY tELSE BODY {if ( $3 ) $5 else $7 }
   ;

WHILE : tWHILE tOP CALC tCP BODY { while ( $3 ) $5 }
      ;

CALC :  NUMBRE
      | CALC tADD NUMBRE
      | CALC tMUL NUMBRE
      | CALC tDIV NUMBRE
      | CALC tSUB NUMBRE
      | CALC tMODULO NUMBRE
      | CALC tGE NUMBRE
      | CALC tLE NUMBRE
      | CALC tLT NUMBRE
      | CALC tBT NUMBRE
      | CALC tNE NUMBRE
      | CALC tCOMP NUMBRE
      | CALC tOR NUMBRE
      | CALC tAND NUMBRE
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
