%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "table_symb.h"

void yyerror(char *s);
int yylex();

extern FILE* yyin;
FILE* asmfile;

int regCount = 0;

char* new_register() {
    char* reg = malloc(10);
    sprintf(reg, "R%d", regCount++);
    return reg;
}

int labelCount = 0;
char* new_label(const char* base) {
    char* label = malloc(20);
    sprintf(label, "%s_%d", base, labelCount++);
    return label;
}

char* current_else_label;
char* current_endif_label;


%}

%union {
    int nb;
    char* var;
    char* reg;
}

/* Tokens with values */
%token <nb> tNB
%token <var> tID

/* Simple tokens */
%token tCOMP tEQ tBT tLT tSUB tADD tMUL tDIV tMODULO tOP tCP tIF tELSE tWHILE tPOINT tSHARP
%token tINT tCHAR tFLOAT tSTRING tOB tCB tCOMA tSEMICOL tNULL
%token tAND tOR tRETURN tPRINT tERROR tGE tLE tNE

/* Non-terminals returning register names */
%type <reg> CALC NUMBRE

/* Precedence */
%left tOR
%left tAND
%left tCOMP tNE tGE tLE tLT tBT
%left tADD tSUB
%left tMUL tDIV tMODULO

%nonassoc LOWER_THAN_ELSE
%nonassoc tELSE

%start C
%%

C:
    /* empty */
  | C FUNCTION
  ;

TYPE:
    tINT
  ;

BODY:
    tOB INBODY tCB
  ;

INBODY:
    /* empty */
  | INSTRUCTION INBODY
  | RETURN
  ;

INSTRUCTION:
    DECLARATION
  | IF
  | WHILE
  | AFFECTATION
  | PRINT
  ;

FUNCTION:
    TYPE tID tOP ARGUMENTS tCP BODY
  ;

PRINT:
    tPRINT tOP CALC tCP tSEMICOL {
        fprintf(asmfile, "PRINT %s\n", $3);
    }
  ;

ARGUMENTS:
    /* empty */
  | TYPE tID
  | TYPE tID tCOMA ARGUMENTS
  ;

DECLARATION:
    TYPE tID tEQ CALC tSEMICOL {
        char *reg = new_register();
        add_var(table_symbole, "int", 0, $4, 1, $2); // Add initialized var
        fprintf(asmfile, "MOV %s, %s\n", reg, $4);
    }
  | TYPE tID tSEMICOL {
        char *reg = new_register();
        add_var(table_symbole, "int", 0, reg, 0, $2); // Add uninitialized var
        // No MOV
    }
  ;

AFFECTATION:
    tID tEQ CALC tSEMICOL {
        struct ligne* l = recup_ligne(table_symbole, $1);
        if (!l) {
            fprintf(stderr, "Variable %s not declared\n", $1);
            exit(1);
        }
        fprintf(asmfile, "MOV %s, %s\n", l->value, $3);
    }
  ;

IF:
    tIF tOP CALC tCP {
        // Mid-rule action: done *before* the BODY executes
        current_else_label = new_label("ELSE");
        current_endif_label = new_label("ENDIF");
        fprintf(asmfile, "JZ %s, %s\n", $3, current_else_label);
    }
    BODY {
        // Mid-rule action: after THEN-body is emitted
        fprintf(asmfile, "JMP %s\n", current_endif_label);
        fprintf(asmfile, "%s:\n", current_else_label);
    }
    tELSE
    BODY {
        // Final label after ELSE-body
        fprintf(asmfile, "%s:\n", current_endif_label);
    }
;

WHILE:
    tWHILE tOP CALC tCP BODY {
        fprintf(asmfile, "; WHILE loop with condition %s\n", $3);
    }
  ;

CALC:
    NUMBRE
  | CALC tADD CALC {
        $$ = new_register();
        fprintf(asmfile, "ADD %s, %s, %s\n", $$, $1, $3);
    }
  | CALC tSUB CALC {
        $$ = new_register();
        fprintf(asmfile, "SUB %s, %s, %s\n", $$, $1, $3);
    }
  | CALC tMUL CALC {
        $$ = new_register();
        fprintf(asmfile, "MUL %s, %s, %s\n", $$, $1, $3);
    }
  | CALC tDIV CALC {
        $$ = new_register();
        fprintf(asmfile, "DIV %s, %s, %s\n", $$, $1, $3);
    }
  | CALC tMODULO CALC {
        $$ = new_register();
        fprintf(asmfile, "MOD %s, %s, %s\n", $$, $1, $3);
    }
  | CALC tCOMP CALC {
        $$ = new_register();
        fprintf(asmfile, "CMP_EQ %s, %s, %s\n", $$, $1, $3);
    }
  | CALC tNE CALC {
        $$ = new_register();
        fprintf(asmfile, "CMP_NE %s, %s, %s\n", $$, $1, $3);
    }
  | CALC tGE CALC {
        $$ = new_register();
        fprintf(asmfile, "CMP_GE %s, %s, %s\n", $$, $1, $3);
    }
  | CALC tLE CALC {
        $$ = new_register();
        fprintf(asmfile, "CMP_LE %s, %s, %s\n", $$, $1, $3);
    }
  | CALC tLT CALC {
        $$ = new_register();
        fprintf(asmfile, "CMP_LT %s, %s, %s\n", $$, $1, $3);
    }
  | CALC tBT CALC {
        $$ = new_register();
        fprintf(asmfile, "CMP_GT %s, %s, %s\n", $$, $1, $3);
    }
  | CALC tAND CALC {
        $$ = new_register();
        fprintf(asmfile, "AND %s, %s, %s\n", $$, $1, $3);
    }
  | CALC tOR CALC {
        $$ = new_register();
        fprintf(asmfile, "OR %s, %s, %s\n", $$, $1, $3);
    }
  | tOP CALC tCP {
        $$ = $2;
    }
  ;

NUMBRE:
    tNB {
        $$ = new_register();
        fprintf(asmfile, "MOV %s, %d\n", $$, $1);
    }
  | tID {
        struct ligne* l = recup_ligne(table_symbole, $1);
        if (!l) {
            fprintf(stderr, "Variable %s not declared\n", $1);
            exit(1);
        }
        $$ = strdup(l->value); // Return the register name
    }
  ;

RETURN:
    tRETURN CALC tSEMICOL {
        fprintf(asmfile, "RET %s\n", $2);
    }
  ;
%%

extern int yylineno;

void yyerror(char *msg) {
    fprintf(stderr, "error: '%s' at line %d.\n", msg, yylineno);
    exit(1);
}

int main(void) {
    asmfile = fopen("output.asm", "w");
    if (!asmfile) {
        perror("fopen");
        return 1;
    }

    // Optional: clear symbol table at start
    memset(table_symbole, 0, sizeof(table_symbole));

    yyparse();
    fclose(asmfile);
    printf("compilation réussie :)\n");
    return 0;
}
