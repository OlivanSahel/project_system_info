#include "symbole_table.h"
#include <string.h>

table_main* head_main = NULL;
table_temp* head_temp = NULL;
table_scope* scope = NULL;


int current_size_main = 0;
int current_size_temp = 0;
/*
    il faut qu'on fasse la fonction pour rajouter un scope => on l'appel quand on trouve un "{". 
    il faut qu'on retire un scope => on le fait dans unstack_main.
*/

//is_temp is to decide which stack we are using
//create new line and insert it at the top of the stack
void add_main(table_main tab, char* ID, int adress, char* type) {
    table_main* new_line = (table_main*)malloc(sizeof(table_main));

    if (new_line == NULL) {
        printf("Memory allocation failed\n");
        return;
    }
    
    new_line->ID = strdup(ID);
    new_line->type = strdup(type);
    new_line->adress = adress;

    new_line->next = head_main;
    head_main = new_line;
    current_size_main++;
    
    if (scope == NULL){
        scope -> numbre_elements_in_scope = 0;
    }
    scope -> numbre_elements_in_scope++;
}

void add_temp(table_temp tab, int adress) {
    table_temp* new_line = (table_temp*)malloc(sizeof(table_temp));

    if (new_line == NULL) {
        printf("Memory allocation failed\n");
        return;
    }
    
    new_line->adress = adress;
    new_line->ID = strdup(current_size_temp);

    new_line->next = head_temp;
    head_temp = new_line;
    current_size_temp++;
}

// Get the address of a symbol by ID
int get_adress_main(char* ID) {
    table_main * current;

    table_main* current = head_main;

    
    while (current != NULL) {
        if (strcmp(current->ID, ID) == 0) {
            return current->adress;
        }
        current = current->next;
    }
    
    printf("Symbol '%s' not found\n", ID);
    return -1;
}

int get_adress_temp(char* ID) {
    table_temp * current;

    table_temp* current = head_temp;

    while (current != NULL) {
        if (strcmp(current->ID, ID) == 0) {
            return current->adress;
        }
        current = current->next;
    }
    
    printf("Symbol '%s' not found\n", ID);
    return -1;
}

// Remove the specified number of elements from the top of the stack
void unstack_main(int numbre_of_remove) {
    if (numbre_of_remove <= 0 || head_main == NULL) {
        return;
    }
    
    int count = 0;
    while (head_main != NULL && count < numbre_of_remove) {
        table_main* aux = head_main;
        head_main = head_main->next;
        
        // Free the allocated memory for strings
        free(aux->ID);
        free(aux->type);
        free(aux->adress);
        free(aux);
        
        count++;
        current_size_main--;

        
    }
    table_scope * scope_temp=scope;
    scope=scope->next;
    free (scope_temp->numbre_elements_in_scope);
    free (scope_temp);
}

void unstack_temp(int numbre_of_remove) {
    if (numbre_of_remove <= 0 || head_temp == NULL) {
        return;
    }
    
    int count = 0;
    while (head_temp != NULL && count < numbre_of_remove) {
        table_temp* aux = head_temp;
        head_temp = head_temp->next;
        
        // Free the allocated memory for strings
        free(aux->ID);
        free(aux -> adress);
        free(aux);
        
        count++;
        current_size_temp--;
    }
}