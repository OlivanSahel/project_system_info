//#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>
struct ligne{
    int type;
    int isglobal;
    char* value;
    int isinit;
    char* name;
    int istemp;
}ligne;

struct ligne table_symbole[256]={NULL};


void add_var(struct ligne * table,int type,int isglobal,char* val, int isinit, char* name){//ajoute a la premiere place dispo ou modifie la variable si elle existe deja
    int i=0;
    while (table[i].type!=NULL && table[i].name!=name){
        i++;
        if (i==256){
            printf("No Place left");
            exit(EXIT_FAILURE);
        }
    }
    table[i].type=type;
    table[i].isglobal=isglobal;
    table[i].value=val;
    table[i].isglobal=isinit;
    table[i].name=name;
    table[i].istemp=0;

}

void supr_var(struct ligne * table,char * name){
    int i=0;
    while (table[i].name!=name){
        i++;
        if (i==256){
            printf("Not Found");
            exit(EXIT_FAILURE);
        }
    }
    table[i].type=NULL;
}

void add_var_temp(struct ligne * table,int type,int isglobal,char* val, int isinit, char* name){
    int i=255;
    while (table[i].type!=NULL){
        i--;
        if (i==-1){
            printf("No Space left");
            exit(EXIT_FAILURE);
        }
    }
    
    table[i].type=type;
    table[i].isglobal=isglobal;
    table[i].value=val;
    table[i].isinit=isinit;
    table[i].name=name;
    table[i].istemp=1;

}

void supr_var_temp(struct ligne * table,char * name){
    int i=255;
    int j=255;
    while (table[i].name!=name){
        i--;
        if (i==-1){
            printf("Not Found");
            exit(EXIT_FAILURE);
        }
    }
    while (table[j].istemp==1 && j>0){
        j--;
        table[j].type=table[j-1].type;
        table[j].isglobal=table[j-1].isglobal;
        table[j].value=table[j-1].value;
        table[j].isinit=table[j-1].isinit;
        table[j].name=table[j-1].name;
    }
    table[j].type=NULL;
}

struct ligne recup_ligne (struct ligne * table,char * name){
    int i=0;
    while (table[i].name!=name){
        i++;
        if (i==256){
            printf("Not Found");
            exit(EXIT_FAILURE);
        }
    }
    return table[i];
}

struct ligne recup_ligne_temp (struct ligne * table){
    return table[255];
}


char* get_valeur(struct ligne * table,char * name){
    return recup_ligne(table,name).value;
}

int get_type(struct ligne * table,char * name){
    return recup_ligne(table,name).type;
}

int get_isglobal(struct ligne * table,char * name){
    return recup_ligne(table,name).isglobal;
}

int get_isinit(struct ligne * table,char * name){
    return recup_ligne(table,name).isinit;
}


char* get_valeur_temp(struct ligne * table){
    return recup_ligne_temp(table).value;
}

int get_type_temp(struct ligne * table){
    return recup_ligne_temp(table).type;
}

int get_isglobal_temp(struct ligne * table){
    return recup_ligne_temp(table).isglobal;
}

int get_isinit_temp(struct ligne * table){
    return recup_ligne_temp(table).isinit;
}
