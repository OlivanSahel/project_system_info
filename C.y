%{
#include <stdlib.h>
#include <stdio.h>
int var[26];
void yyerror(char *s);
%}

%union {  
  int nb; 
  char* var; 
}

%token tCOMP tEQ tBT tLT tSUB tADD tMUL tDQUOTE tQUOTE tDIV tMODULO tOP tCP tIF tELSE tWHILE tPOINT tSHARP tINT tCHAR tFLOAT tSTRING tOB tCB tCOMA tSEMICOL tNULL 
%token tAND tOR tRETURN tPRINT tFL tERROR tGE tLE tNE
%token <nb> tNB
%token <var> tID
%start C
%%

C: /* epsilon */
  | C INBODY
  ;

TYPE :  tINT 
      | tCHAR
      | tSTRING
      | tFLOAT
      ;


BODY: tOB INBODY tCB   

INBODY : INBODY tSEMICOL INBODY
        | DECLARATION
        | IF
        | FUNCTION
        | WHILE
        |AFFECTATION

        ;

FUNCTION: TYPE tID tOP ARGUMENTS tCP BODY  

ARGUMENTS: TYPE tID                 
          | TYPE tID tCOMA ARGUMENTS  
          ;

DECLARATION : TYPE tID tEQ tID    
            | TYPE tID tEQ TYPE   
            | TYPE tID           
            | TYPE tID tEQ FUNCTION  
            |TYPE tID tEQ CONDITION
            |TYPE tID tEQ CALC
            ;

AFFECTATION : tID tEQ tID   
            | tID tEQ VAL    
            | tID tEQ FUNCTION     
            | tID tEQ CONDITION
            | tID tEQ CALC
            ;

COMPARISON : tCOMP | tNE | tLT |tBT |tLE |tGE |tAND | 

CONDITION : BODY COMPARISON BODY

IF : tIF tOP CONDITION tCP BODY       
    |tIF tOP CONDITION tCP BODY tELSE BODY
   ;

WHILE : tWHILE tOP CONDITION tCP BODY      
   ;

OPERATION: tADD
          | tSUB
          | tDIV
          | tMUL
          | tMODULO
          ;

STRING: tDQUOTE tID tDQUOTE ;

VAL : tID
      | tNB
      | STRING
      ;

CALC : VAL OPERATION VAL 
          | VAL OPERATION CALC 
          ;


%%
void yyerror(char *s) { fprintf(stderr, "%s\n", s); }
int main(void) {
  yyparse();
  return 0;
}
