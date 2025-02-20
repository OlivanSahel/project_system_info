#include<stdlib.h>
#include<stdio.h>
#define MAX_SIZE 128

int EcritFichier(FILE * fich_lect, char* nom_fich_ecrit, int nb_lignes){
	FILE * fich_ecrit = fopen(nom_fich_ecrit,"w");

	if (fich_lect == NULL && fich_ecrit == NULL){
		return 1;
	}

	char * buffer = malloc(MAX_SIZE);
	fgets(buffer, MAX_SIZE, fich_lect);
	fputs(buffer, fich_ecrit);
	
	fclose(fich_lect);
	fclose(fich_ecrit);	
	return(0);
}


int main(int argc, char* argv[]){
	/*if (argc > 2 ){
		return(1);
	} */
	int err = EcritFichier(fopen(argv[0],"r"), argv[1], 2);
	printf("%d", err);

	return(0);
}
