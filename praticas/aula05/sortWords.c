#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int compareStrings(const void *px1, const void *px2)
{
    return strcmp(px1,px2);
}

int compareStringsReverse(const void *px1, const void *px2)
{
    return ! strcmp(px1,px2);
}

int main(int argc, char *argv[]){
	if(argc < 2){
		printf("Invalid number of arguments!\n");
		return EXIT_FAILURE;
	}

    char *order = getenv("order");
    if(order == NULL){
        printf("ERROR: SORTORDER not defined\n");
        return EXIT_FAILURE;
    }

	int charAmmount = 0;
    int wordAmmount = 0;

	for(int i = 1 ; i < argc ; i++){
		charAmmount += strlen(argv[i]);
	}

	char phrase[argc][charAmmount];
  
	for(int i = 1 ; i < argc ; i++){
		if(! isalpha(argv[i][0])){
            continue;
		}

        strcpy(phrase[wordAmmount],argv[i]);    
        wordAmmount++;


	}


    
    if((strcmp(order,"crescente") == 0)){           
        qsort(phrase, argc-1, charAmmount, compareStrings);
    }else if((strcmp(order,"decrescente") == 0)){
        qsort(phrase, argc-1, charAmmount, compareStringsReverse);
    }



	for(int i = 0; i <= wordAmmount; i++){
		printf("%s ",phrase[i]);
	}
	printf("\n");
	
	return EXIT_SUCCESS;
}