#ifndef TABLE_SYMBOL_H
#define TABLE_SYMBOL_H

#define TABLE_SIZE 15

struct ligne {
    char* type;
    int isglobal;
    char* value;
    int isinit;
    char* name;
    int istemp;
};

extern struct ligne table_symbole[TABLE_SIZE];

char* alloc_register();
void free_register(char* reg);
void add_var(struct ligne* table, const char* type, int isglobal, const char* val, int isinit, const char* name);
void supr_var(struct ligne* table, const char* name);
struct ligne* recup_ligne(struct ligne* table, const char* name);

#endif // TABLE_SYMBOL_H
