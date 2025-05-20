%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "table_symb.h"

void yyerror(char *s);
int yylex();

extern FILE* yyin;
FILE* asmfile;

#define MAX_REGS 256
char* used_regs[MAX_REGS] = {0};

int regCount = 0;

int labelCount = 0;
char* new_label(const char* base) {
    char* label = malloc(20);
    sprintf(label, "%s_%d", base, labelCount++);
    return label;
}

char* current_else_label;
char* current_endif_label;
char* current_while_start;
char* current_while_end;
%}
w
%union {
    int nb;
    char* var;
    char* reg;
}

%token <nb> tNB
%token <var> tID

%token tCOMP tEQ tBT tLT tSUB tADD tMUL tDIV tMODULO tOP tCP tIF tELSE tWHILE tPOINT tSHARP
%token tINT tCHAR tFLOAT tSTRING tOB tCB tCOMA tSEMICOL tNULL
%token tAND tOR tRETURN tPRINT tERROR tGE tLE tNE tCONST

%type <reg> CALC NUMBRE
%type <var> TYPE

%start C

%left tOR
%left tAND
%left tCOMP tNE tGE tLE tLT tBT
%left tADD tSUB
%left tMUL tDIV tMODULO
%nonassoc tELSE
%%

C:
    /* empty */
  | C FUNCTION
  ;

TYPE:
    tINT   { $$ = "int"; }
  | tCONST tINT { $$ = "const"; }
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
        free_register($3);
    }
  ;

ARGUMENTS:
    /* empty */
  | TYPE tID
  | TYPE tID tCOMA ARGUMENTS
  ;

DECLARATION:
    TYPE tID tEQ CALC tSEMICOL {
        add_var(table_symbole, $1, 0, $4, 1, $2);
    }
  | TYPE tID tSEMICOL {
        char *reg = alloc_register();
        add_var(table_symbole, $1, 0, reg, 0, $2);
    }
  ;

AFFECTATION:
    tID tEQ CALC tSEMICOL {
        struct ligne* l = recup_ligne(table_symbole, $1);
        if (!l) {
            fprintf(stderr, "Variable %s not declared\n", $1);
            exit(1);
        }
        if (strcmp(l->type, "const") == 0) {
            fprintf(stderr, "Cannot assign to const variable %s\n", $1);
            exit(1);
        }
        if (strcmp(l->value, $3) != 0) {
          fprintf(asmfile, "MOV %s, %s\n", l->value, $3);
          free_register($3);
        } else {
            // No move needed, but still mark it as freed since $3 was temp
            // This may be unnecessary if it's being retained as a var now
        }

    }
  ;

IF:
    tIF tOP CALC tCP {
        current_else_label = new_label("ELSE");
        current_endif_label = new_label("ENDIF");
        fprintf(asmfile, "JZ %s, %s\n", $3, current_else_label);
        free_register($3);
    }
    BODY {
        fprintf(asmfile, "JMP %s\n", current_endif_label);
        fprintf(asmfile, "%s:\n", current_else_label);
    }
    tELSE
    BODY {
        fprintf(asmfile, "%s:\n", current_endif_label);
    }
  ;

WHILE:
    tWHILE {current_while_start = new_label("WHILE_START");
    fprintf(asmfile, "%s:\n", current_while_start);
    }tOP CALC tCP {
        current_while_end = new_label("WHILE_END");
        fprintf(asmfile, "JZ %s, %s\n", $4, current_while_end);
        free_register($4);
    }
    BODY {
        fprintf(asmfile, "JMP %s\n", current_while_start);
        fprintf(asmfile, "%s:\n", current_while_end);
    }
  ;

CALC:
    NUMBRE
  | CALC tADD CALC {
        $$ = alloc_register();
        fprintf(asmfile, "ADD %s, %s, %s\n", $$, $1, $3);
        free_register($1);
        free_register($3);
    }
  | CALC tSUB CALC {
        $$ = alloc_register();
        fprintf(asmfile, "SUB %s, %s, %s\n", $$, $1, $3);
        free_register($1);
        free_register($3);
    }
  | CALC tMUL CALC {
        $$ = alloc_register();
        fprintf(asmfile, "MUL %s, %s, %s\n", $$, $1, $3);
        free_register($1);
        free_register($3);
    }
  | CALC tDIV CALC {
        $$ = alloc_register();
        fprintf(asmfile, "DIV %s, %s, %s\n", $$, $1, $3);
        free_register($1);
        free_register($3);
    }
  | CALC tMODULO CALC {
        $$ = alloc_register();
        fprintf(asmfile, "MOD %s, %s, %s\n", $$, $1, $3);
        free_register($1);
        free_register($3);
    }
  | CALC tCOMP CALC {
        $$ = alloc_register();
        fprintf(asmfile, "CMP_EQ %s, %s, %s\n", $$, $1, $3);
        free_register($1);
        free_register($3);
    }
  | CALC tNE CALC {
        $$ = alloc_register();
        fprintf(asmfile, "CMP_NE %s, %s, %s\n", $$, $1, $3);
        free_register($1);
        free_register($3);
    }
  | CALC tGE CALC {
        $$ = alloc_register();
        fprintf(asmfile, "CMP_GE %s, %s, %s\n", $$, $1, $3);
        free_register($1);
        free_register($3);
    }
  | CALC tLE CALC {
        $$ = alloc_register();
        fprintf(asmfile, "CMP_LE %s, %s, %s\n", $$, $1, $3);
        free_register($1);
        free_register($3);
    }
  | CALC tLT CALC {
        $$ = alloc_register();
        fprintf(asmfile, "CMP_LT %s, %s, %s\n", $$, $1, $3);
        free_register($1);
        free_register($3);
    }
  | CALC tBT CALC {
        $$ = alloc_register();
        fprintf(asmfile, "CMP_GT %s, %s, %s\n", $$, $1, $3);
        free_register($1);
        free_register($3);
    }
  | CALC tAND CALC {
        $$ = alloc_register();
        fprintf(asmfile, "AND %s, %s, %s\n", $$, $1, $3);
        free_register($1);
        free_register($3);
    }
  | CALC tOR CALC {
        $$ = alloc_register();
        fprintf(asmfile, "OR %s, %s, %s\n", $$, $1, $3);
        free_register($1);
        free_register($3);
    }
  | tOP CALC tCP {
        $$ = $2;
    }
  ;

NUMBRE:
    tNB {
        $$ = alloc_register();
        fprintf(asmfile, "MOV %s, %d\n", $$, $1);
    }
  | tID {
        struct ligne* l = recup_ligne(table_symbole, $1);
        if (!l) {
            fprintf(stderr, "Variable %s not declared\n", $1);
            exit(1);
        }
        $$ = alloc_register();
        fprintf(asmfile, "MOV %s, %s\n", $$, l->value);
    }
  ;

RETURN:
    tRETURN CALC tSEMICOL {
        fprintf(asmfile, "RET %s\n", $2);
        free_register($2);
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

    memset(table_symbole, 0, sizeof(table_symbole));

    yyparse();
    fclose(asmfile);
    printf("compilation réussie :)\n");
    return 0;
}