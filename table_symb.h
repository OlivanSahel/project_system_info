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

void add_var(struct ligne* table, const char* type, int isglobal, const char* val, int isinit, const char* name);
void supr_var(struct ligne* table, const char* name);
void add_var_temp(struct ligne* table, const char* type, int isglobal, const char* val, int isinit, const char* name);
void supr_var_temp(struct ligne* table, const char* name);
struct ligne* recup_ligne(struct ligne* table, const char* name);
struct ligne* recup_ligne_temp(struct ligne* table);

const char* get_valeur(struct ligne* table, const char* name);
const char* get_valeur_temp(struct ligne* table);
int get_isglobal(struct ligne* table, const char* name);
int get_isinit(struct ligne* table, const char* name);
int get_isglobal_temp(struct ligne* table);
int get_isinit_temp(struct ligne* table);
const char* get_type(struct ligne* table, const char* name);
const char* get_type_temp(struct ligne* table);

void afftab(struct ligne* table);

#endif // TABLE_SYMBOL_H
