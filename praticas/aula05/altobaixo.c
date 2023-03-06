#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main (int argc, char *argv[]){

    char *min=argv[1];
    int liminf=atoi(min);
    char *max=argv[2];
    int limisup=atoi(max);
    int value = rand();
    int success = 0;
    int guess = 0;
    int tentativa = 0;
    while (success == 0){
        if (value >= liminf && value <= limisup){
            success = 1;
        }
        else{
            value = rand();
            success = 0;
        }
    }

    do {
        printf("Insira um valor: ");
        scanf ("%i", &guess);
        tentativa +=1;
        if (guess > value){
            printf("Valor alto, insira um menor\n");
        }
        else if(guess < value){
            printf("Valor baixo, insira um maior \n");
        }
    }
    while(guess != value);
    printf("Valor correto!\n");
    printf("Numero de tentativas: %i\n", tentativa);
}