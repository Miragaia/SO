#include <stdio.h>
#include <string.h>
#include <ctype.h>
int main(int argc,char **argv){
int tamanho=0;
 for (int i=0;i<argc;i++){
	tamanho+=strlen(argv[i]);
}
char phrase[tamanho+argc];
const char *space=" ";
 for (int j=1;j<argc;j++){
	if(j==1){
        if (isalpha(argv[j][0])){
            strcpy(phrase,argv[j]); //strcat adiciona a str para o fim do array deixando o espaco alocado com memoria inicial com memoria random. Para corrigir
            //este problema usamos o strcpy para a primeira posicao que substitui a memoria random alocada pro inicio do array colocando a str desejada no inicio.
            strcat(phrase,space);
        }
        else{
            continue;
        }
	}
	else{
        if (isalpha(argv[j][0])){
            strcat(phrase,argv[j]);
            strcat(phrase,space);
        }
        else{
            continue;
        }
	}
}
printf("%s\n",phrase);
 return 0;
}