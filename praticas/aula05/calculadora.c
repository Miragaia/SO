#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>


int main(int argc, char *argv[]){
    if (argc != 4){
	    printf("Numero incorreto de argumentos! \n");
    }else{
        char* ptr;
        char* ptr2;
        double argumento1=strtod(argv[1],&ptr);
        double argumento2=strtod(argv[3],&ptr2);

        switch (*argv[2])
        {
        case '+':
            printf("%f \n",argumento1+argumento2);
            break;
         case '-':
            printf("%f \n",argumento1-argumento2);
            break;
         case 'x':
            printf("%f \n",argumento1*argumento2);
            break;
         case '/':
            printf("%f \n",argumento1/argumento2);
            break;
         /*case 'p':
            printf("%f \n",pow(argumento1,argumento2));
            break;*/  //da erro ns pq
        }
    }
}