#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int main(int argc, char const *argv[]) 
{
    int stat;
    printf("==================================================\n");

    switch (fork()) {
        case -1: //Falha
            perror("Erro na criação do processo filho\n");
            return EXIT_FAILURE;
        case 0: //Filho
            sleep(2);
            if(execlp("ls","ls", "-la", NULL) < 0){
                perror("Erro ao executar a funcao execl()\n");
                return EXIT_FAILURE;
            }
        case 1: //Pai
            if(wait(&stat) < 0){
                perror("Erro na espera pelo processo filho\n");
                return EXIT_FAILURE;
            }
            else{
                printf("==================================================\n");
            }
    }
    return EXIT_SUCCESS;
}