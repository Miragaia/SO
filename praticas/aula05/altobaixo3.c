#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include<time.h>

int main(int argc, char *argv[])
{
    int esnumber=-1;
    int randomNumber=0;
    int contador=0;

    char *minimo=argv[1];
    int min=atoi(minimo);
    char *maximo=argv[2];
    int max=atoi(maximo);

    srand(time(NULL)); 
    randomNumber=(rand() %(max - min + 1)) + min;
    puts("\n");


    while(randomNumber!=esnumber){
        if (esnumber==-1){
            printf("Welcome to the 'Guessing Number' game \nGood Luck!\n \n");
        }
        else if (esnumber>randomNumber){
            puts("High");
        }
        else if (esnumber<randomNumber){
            puts("Short");
        }
        printf("Choose a Number please: ");
        scanf("%d",&esnumber);
        contador++;
    }


    puts("Parabéns acertaste no número!!");
    printf("Depois de %i tentativas",contador);
    puts("\n");
    return 0;
}
