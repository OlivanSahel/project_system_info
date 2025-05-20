#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#define MAX_REGS 256

#define TABLE_SIZE 255

struct ligne {
    char* type;
    int isglobal;
    char* value;
    int isinit;
    char* name;
    int istemp;
};

struct ligne table_symbole[TABLE_SIZE] = {0};


static int reg_in_use[MAX_REGS] = {0};  // 0 means free, 1 means in use

char* alloc_register() {
    for (int i = 0; i < MAX_REGS; i++) {
        if (!reg_in_use[i]) {
            reg_in_use[i] = 1;
            char* reg = malloc(10);
            sprintf(reg, "R%d", i);
            return reg;
        }
    }
    fprintf(stderr, "Out of registers!\n");
    exit(1);
}

void free_register(char* reg) {
    if (reg && reg[0] == 'R') {
        int num = atoi(&reg[1]);
        if (num >= 0 && num < MAX_REGS) {
            reg_in_use[num] = 0;
            free(reg);
            return;
        }
    }
    fprintf(stderr, "Invalid register to free: %s\n", reg);
    exit(1);
}

void add_var(struct ligne* table, const char* type, int isglobal, const char* val, int isinit, const char* name) {
    int i = 0;
    while (i < TABLE_SIZE && table[i].name != NULL) {
        if (strcmp(table[i].name, name) == 0) {
            printf("Variable '%s' already declared.\n", name);
            return;
        }
        i++;
    }

    if (i == TABLE_SIZE) {
        printf("No space left in symbol table.\n");
        exit(EXIT_FAILURE);
    }

    table[i].type = strdup(type);
    table[i].isglobal = isglobal;
    table[i].value = strdup(val);
    table[i].isinit = isinit;
    table[i].name = strdup(name);
    table[i].istemp = 0;
}

void supr_var(struct ligne* table, const char* name) {
    for (int i = 0; i < TABLE_SIZE; i++) {
        if (table[i].name && strcmp(table[i].name, name) == 0) {
            free(table[i].type);
            free(table[i].value);
            free(table[i].name);
            table[i].type = NULL;
            table[i].value = NULL;
            table[i].name = NULL;
            table[i].istemp = 0;
            return;
        }
    }
    printf("Variable '%s' not found.\n", name);
}

struct ligne* recup_ligne(struct ligne* table, const char* name) {
    for (int i = 0; i < TABLE_SIZE; i++) {
        if (table[i].name && strcmp(table[i].name, name) == 0) {
            return &table[i];
        }
    }
    printf("Variable '%s' not found.\n", name);
    exit(EXIT_FAILURE);
}
