#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define TABLE_SIZE 15
#define EXIT_FAILURE -1

struct ligne {
    char* type;
    int isglobal;
    char* value;
    int isinit;
    char* name;
    int istemp;
};



struct ligne table_symbole[TABLE_SIZE] = {0};

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

void add_var_temp(struct ligne* table, const char* type, int isglobal, const char* val, int isinit, const char* name) {
    for (int i = TABLE_SIZE - 1; i >= 0; i--) {
        if (table[i].name == NULL) {
            table[i].type = strdup(type);
            table[i].isglobal = isglobal;
            table[i].value = strdup(val);
            table[i].isinit = isinit;
            table[i].name = strdup(name);
            table[i].istemp = 1;
            return;
        }
    }
    printf("No space left for temporary variable.\n");
    exit(EXIT_FAILURE);
}

void supr_var_temp(struct ligne* table, const char* name) {
    for (int i = TABLE_SIZE - 1; i >= 0; i--) {
        if (table[i].name && table[i].istemp && strcmp(table[i].name, name) == 0) {
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
    printf("Temporary variable '%s' not found.\n", name);
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

struct ligne* recup_ligne_temp(struct ligne* table) {
    for (int i = TABLE_SIZE - 1; i >= 0; i--) {
        if (table[i].name && table[i].istemp) {
            return &table[i];
        }
    }
    printf("No temporary variable found.\n");
    exit(EXIT_FAILURE);
}

const char* get_valeur(struct ligne* table, const char* name) {
    return recup_ligne(table, name)->value;
}

const char* get_valeur_temp(struct ligne* table) {
    return recup_ligne_temp(table)->value;
}

int get_isglobal(struct ligne* table, const char* name) {
    return recup_ligne(table, name)->isglobal;
}

int get_isinit(struct ligne* table, const char* name) {
    return recup_ligne(table, name)->isinit;
}

int get_isglobal_temp(struct ligne* table) {
    return recup_ligne_temp(table)->isglobal;
}

int get_isinit_temp(struct ligne* table) {
    return recup_ligne_temp(table)->isinit;
} 

const char* get_type(struct ligne* table, const char* name) {
    return recup_ligne(table, name)->type;
}        

const char* get_type_temp(struct ligne* table) {
    return recup_ligne_temp(table)->type;
}

void afftab(struct ligne* table) {
    printf("\n---- Table des Symboles ----\n");
    for (int i = 0; i < TABLE_SIZE; i++) {
        if (table[i].name != NULL) {
            printf("Name: %-10s | Type: %-6s | Value: %-10s | Init: %d | Global: %d | Temp: %d\n",
                table[i].name, table[i].type, table[i].value,
                table[i].isinit, table[i].isglobal, table[i].istemp);
        }
    }
    printf("-----------------------------\n");
}

#ifdef TEST
int main(void) {
    afftab(table_symbole);

    add_var(table_symbole, "int", 1, "43", 1, "vartest1");
    add_var(table_symbole, "int", 1, "100", 1, "vartest2");

    afftab(table_symbole);

    supr_var(table_symbole, "vartest1");

    afftab(table_symbole);

    add_var_temp(table_symbole, "int", 0, "999", 1, "tmp1");

    afftab(table_symbole);

    supr_var_temp(table_symbole, "tmp1");

    afftab(table_symbole);

    return 0;
}
#endif