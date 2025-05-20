#ifndef symbole_table.h

typedef struct table_{
    char* ID;
    int adress;
    char* type;
    struct table_ * next;
}table_main;

typedef struct table_temp{
    int adress;
    char* ID;
    struct table_temp* next;
}table_temp;

typedef struct table_scope_{
    int numbre_elements_in_scope;
    struct table_scope_* next;
}table_scope;

table_main* head_main;
table_temp* head_temp;
table_scope* scope;

int current_size_main;
int current_size_temp;

void add_main(table_main tab, char* ID, char* type);
void add_temp(table_temp tab, char* ID);

int get_adress_main(char* ID);
int get_adress_temp(char* ID);

void unstack_main(int numbre_of_remove);
void unstack_temps(int numbre_of_remove);

#endif
