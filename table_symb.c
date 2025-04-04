//#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

struct ligne{
    char* type[10];
    int isglobal;
    char* value[100];
    int isinit;
    char* name[20];
    int istemp;
}ligne;

const int taille=15;
struct ligne table_symbole[taille]={NULL};


void add_var(struct ligne * table,const char* type,int isglobal,const char* val, int isinit,const char* name){//ajoute a la premiere place dispo ou modifie la variable si elle existe deja
    int i=0;
    while (table[i].type!=NULL && table[i].name!=name){
        i++;
        if (i==taille){
            printf("No Place left");
            exit(EXIT_FAILURE);
        }
    }
    strcpy(table[i].type,*type);
    table[i].isglobal=isglobal;
    strcpy(table[i].value,*val);
    table[i].isglobal=isinit;
    strcpy(table[i].name,*name);
    table[i].istemp=0;

}

void supr_var(struct ligne * table,char * name){
    int i=0;
    while (table[i].name!=name){
        i++;
        if (i==taille){
            printf("Not Found");
            exit(EXIT_FAILURE);
        }
    }
    strcpy(table[i].type,"NULL");
}

void add_var_temp(struct ligne * table,const char* type,int isglobal,const char* val, int isinit,const char* name){
    int i=taille-1;
    while (table[i].type!="NULL"){
        i--;
        if (i==-1){
            printf("No Space left");
            exit(EXIT_FAILURE);
        }
    }
    
    strcpy(table[i].type,*type);
    table[i].isglobal=isglobal;
    strcpy(table[i].value,*val);
    table[i].isinit=isinit;
    strcpy(table[i].name,*name);
    table[i].istemp=1;

}

void supr_var_temp(struct ligne * table,char * name){
    int i=taille-1;
    int j=taille-1;
    while (table[i].name!=name){
        i--;
        if (i==-1){
            printf("Not Found");
            exit(EXIT_FAILURE);
        }
    }
    while (table[j].istemp==1 && j>0){
        j--;
        strcpy(table[j].type,*table[j-1].type);
        table[j].isglobal=table[j-1].isglobal;
        strcpy(table[j].value,*table[j-1].value);
        table[j].isinit=table[j-1].isinit;
        strcpy(table[j].name,*table[j-1].name);
    }
    strcpy(table[j].type,"NULL");
}

struct ligne recup_ligne (struct ligne * table,char * name){
    int i=0;
    while (table[i].name!=name){
        i++;
        if (i==taille){
            printf("Not Found");
            exit(EXIT_FAILURE);
        }
    }
    return table[i];
}

struct ligne recup_ligne_temp (struct ligne * table){
    return table[taille-1];
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

void afftab(struct ligne * table){
    for (int i=0;i<taille;i++){
        struct ligne l=table[i];
        printf("%s | %d | %s | %d | %s | %d \n\n",l.type,l.isglobal,l.value,l.isinit,l.name,l.istemp);
    }
}

int main(void) {
    afftab(table_symbole);
    add_var(table_symbole,"int",1,"43",1,"vartest1");
    afftab(table_symbole);
  }
  