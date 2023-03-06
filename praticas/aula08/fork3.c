#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
    printf("Pai (antes do fork): PID = %u, PPID = %u\n", getpid(), getppid());
    switch (fork())
    {
      //Pai (se der erro nao ha filho)
      case -1: /* fork falhou */
               perror("Erro no fork\n");
               return EXIT_FAILURE;
      //Filho
      case 0:  /* processo filho */
                  //path -> ./child
                  //argv[0] -> ./child
                  //NULL -> Terminator
                  //argc = 0 (o NULL nao conta!!)
               if (execl("ls", "ls","-l", NULL) < 0) {  //exec é chamado uma vez e nunca retorna
                   perror("erro no lancamento da aplicacao");
                   return EXIT_FAILURE;
               }
               printf("Porque é que eu não apareço?\n"); // pq qd se faz um exec nada daí pra frente é executado
               //Porque o processo da child e terminado quando o exec terminar
               break;
      //Pai
      default: /* processo pai */
               sleep(1);
               printf("Pai (depois do fork): PID = %u, PPID = %u\n", getpid(), getppid());
    }

    return EXIT_SUCCESS;
}
