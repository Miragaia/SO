#!/bin/bash

declare -A arrayPro=() #Array onde a 'key' é o PID e está guardada a informação de cada processo
declare -A inputOpt=() #Array onde está guardada a informação das opções passadas como argumentos na chamada da função
declare -A R=() #Array que guarda a informação do rcharpri
declare -A W=() #Array que guarda a informação do wcharpri

regex='^[0-9]+([.][0-9]+)?$' #variável do regex
regData='^((Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)) +[0-9]{1,2} +[0-9]{1,2}:[0-9]{1,2}' #variável 
c=0 #variável de ativação da opção -c
s=0 #variável de ativação da opção -s
e=0 #variável de ativação da opção -e
u=0 #variável de ativação da opção -u
m=0 #variável de ativação da opção -m
M=0 #variável de ativação da opção -M
r=0 #variável de ativação da opção -r
w=0 #variável de ativação da opção -w
p=0 #variável de ativação da opção -p
ordem="-n" #ordem alfabética
ctr=0 #variável controlo

#Função para argumentos invalidos
function options() {
    echo  "Opções Válidas: "
    echo  " -c     : Seleção de processos a utilizar através de uma expressão regular"
    echo  " -s     : Seleção de processos a visualizar num periodo temporal através da data mínima"
    echo  " -e     : Seleção de processos a visualizar num periodo temporal através da data máxima"
    echo  " -u     : Seleção de processos a visualizar através do nome do utilizador"
    echo  " -m     : Seleção dos processos através de uma gama de pids"
    echo  " -M     : Seleção dos processos através de uma gama de pids"
    echo  " -r     : Ordenar em ordem reversa"
    echo  " -w     : Ordenar em ordem aos valores escritos"
    echo  " -p     : Número de processos a visualizar"
}  

function ValData(){

    regData='^((Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)) +[0-9]{1,2} +[0-9]{1,2}:[0-9]{1,2}'

    if [[ $1 == "clear" ]] || [[ $1 =~ ^[0-9]+([.][0-9]+)?$ ]] || [[ "$1" =~ $regData ]]; then
        ctr=1
    fi
}

function ValArg(){
    
    if [[ $1 == "clear" ]] || [[ $1 =~ ^[0-9]+([.][0-9]+)?$ ]]; then
        ctr=1
    fi
}

function printsl() {

    #pval fica com o valor do array por default
    if ! [[ p -eq 1 ]]; then
        pval=${#arrayPro[@]}
    #pval fica com o valor introduzido
    else
        pval=${inputOpt['p']}
    fi

    if [[ w -eq 1 ]]; then
        if [[ $ordem == "-rn" ]]; then
            ordem="-n"
        else 
            ordem="-rn"
        fi 

        #Ordenação da tabela pelo Write Values
        printf '%s \n' "${arrayPro[@]}" | sort $ordem -k7 | head -n $pval

    else 

        printf '%s \n' "${arrayPro[@]}" | sort $ordem -k1 | head -n $pval 

    fi
}

function printProcessos(){
    printf "%-27s %-16s %15s %12s %12s %15s %15s %16s\n" "COMM" "USER" "PID" "READB" "WRITEB" "RATER" "RATEW" "DATE"

    for value in /proc/[[:digit:]]*; do
        if [[ -r $value/status && -r $value/io ]]; then
            PID=$(cat $value/status | grep -w Pid | tr -dc '0-9') # ir buscar o PID
            rcharpri=$(cat $value/io | grep rchar | tr -dc '0-9')   # rchar inicial
            wcharpri=$(cat $value/io | grep wchar | tr -dc '0-9')   # wchar inicial

            if [[ $rcharpri == 0 && $wcharpri == 0 ]]; then
                continue
            else
                R[$PID]=$(printf "%12d\n" "$rcharpri")
                W[$PID]=$(printf "%12d\n" "$wcharpri")
            fi
        fi

    done

    sleep $1

    for value in /proc/[[:digit:]]*; do
        if [[ -r $value/status && -r $value/io ]]; then
            PID=$(cat $value/status | grep -w Pid | tr -dc '0-9')
            user=$(ps -o user= -p $PID)  
            comm=$(cat $value/comm | tr " " "_")  

            if [[ u -eq 1 && ! ${inputOpt['u']} == $user ]]; then #seleção de processos através do nome de utilizador
                continue
            fi

            if [[ c -eq 1 && ! $comm =~ ${inputOpt['c']} ]]; then #seleção de processos através da expressão regular
                continue
            fi
            

            if [[ m -eq 1 ]]; then
                if [[ "$PID" -lt "${inputOpt['m']}" ]]; then #seleção de processos através da gama de PID min
                    continue
                fi
            fi
            if [[ M -eq 1 ]]; then
                if [[ "$PID" -gt "${inputOpt['M']}" ]]; then #seleção de processos através da gama de PID max
                    continue
                fi
            fi

            LANG=en_us_8859_1
            DataInic=$(ps -o lstart= -p $PID)
            DataInic=$(date +"%b %d %H:%M" -d "$DataInic")
            DataSec=$(date -d "$DataInic" +"%b %d %H:%M"+%s | awk -F '[+]' '{print $2}')

            if [[ s -eq 1 ]]; then  #seleção de processos através da data min                                                              
                start=$(date -d "${inputOpt['s']}" +"%b %d %H:%M"+%s | awk -F '[+]' '{print $2}') # data mínima para a opção -s

                if [[ "$DataSec" -lt "$start" ]]; then
                    continue
                fi
            fi

            if [[ e -eq 1 ]]; then  #seleção de processos através da data max                                                            
                end=$(date -d "${inputOpt['e']}" +"%b %d %H:%M"+%s | awk -F '[+]' '{print $2}') # data máxima para a opção -e

                if [[ "$DataSec" -gt "$end" ]]; then
                    continue
                fi
            fi

            rcharsec=$(cat $value/io | grep rchar | tr -dc '0-9')
            wcharsec=$(cat $value/io | grep wchar | tr -dc '0-9') 
            rcharF=$rcharsec-${R[$PID]}
            wcharF=$wcharsec-${W[$PID]}
            RATER=$(echo "scale=2; $rcharF/$1" | bc -l) #calculo do RATER
            RATEW=$(echo "scale=2; $wcharF/$1" | bc -l) #calculo do RATEW

            arrayPro[$PID]=$(printf "%-27s %-16s %15s %12s %12s %15s %15s %16s\n" "$comm" "$user" "$PID" "${R[$PID]}" "${W[$PID]}" "$RATER" "$RATEW" "$DataInic")
        fi
    done

    printsl
}

#lista de argumentos validos
while getopts "c:s:e:u:m:M:rwp:" option; 
do
    if [[ -z "$OPTARG" ]]; then  
        inputOpt[$option]="clear" #se nao existir option input = clear
    else                         
        inputOpt[$option]=${OPTARG} #se nao vai ser igual à option escolhida
    fi
    case $option in
        c) #expressao regular
            input=${inputOpt['c']}
            c=1
            ValArg $input
            if [[ ctr -eq 1 ]];then
                c=0
                echo "Nao introduziu o argumento de -c, um argumento invalido foi introduzido ou foi introduzido de forma errada"
                options
                exit 1
            fi
        ;;
        s) #visualizar data minima
            input=${inputOpt['s']}
            s=1
            ValData $input
            if [[ ctr -eq 1 ]];then
                s=0
                echo "Nao introduziu o argumento de -s, um argumento invalido foi introduzido ou foi introduzido de forma errada"
                options
                exit 1
            fi
        ;;
        e) #visualizar data maxima
            input=${inputOpt['e']}
            e=1
            ValData $input
            if [[ ctr -eq 1 ]];then
                e=0
                echo "Nao introduziu o argumento de -e, um argumento invalido foi introduzido ou foi introduzido de forma errada"
                options
                exit 1
            fi
        ;;
        u) #visualizar através do nome de utilizador
            input=${inputOpt['u']}
            u=1
            ValArg $input
            if [[ ctr -eq 1 ]];then
                u=0
                echo "Nao introduziu o argumento de -u, um argumento invalido foi introduzido ou foi introduzido de forma errada"
                options
                exit 1
            fi
        ;;
        m) #seleção dos processos por gama de PID min
            input=${inputOpt['m']}
            m=1
            if ! [[ ${inputOpt['m']} =~ $regex ]];then 
                m=0
                echo "Nao introduziu o argumento de -m, um argumento invalido foi introduzido ou foi introduzido de forma errada"
                options
                exit 1
            fi
        ;;
        M) #seleção dos processos por gama de PID max
            input=${inputOpt['M']}
            M=1
            if ! [[ ${inputOpt['M']} =~ $regex ]];then
                M=0
                echo "Nao introduziu o argumento de -M, um argumento invalido foi introduzido ou foi introduzido de forma errada"
                options
                exit 1
            fi
        ;;
        r) #visualizar em ordem reversa
            ordem="-rn"
        ;;
        w) #vizualizar por ondem de write values
            w=1 
        ;;
        p) #número de processos a visualizar
            p=1
            if ! [[ ${inputOpt['p']} =~ $regex ]]; then
                p=0
                echo "Um argumento invalido de -p foi introduzido, terá de ser um número, ou foi introduzido de forma errada"
                options
                exit 1
            fi
        ;;
        *) #argumentos inválidos
            echo "ERRO: Opção inválida"
            options
            exit 1
        ;;
    esac
done  

if [[ $# == 0 ]]; then #validar a introdução de pelo menos um argumento(segundos)
    echo "Falta de argumentos, introduza no minimo 1 (segundos)"
    options
    exit 1
fi

if ! [[ ${@: -1} =~ $regex ]]; then #validar se o ultimo argumento é um número
    echo "Argumento final tem de ser um número"
    options
    exit 1
fi


printProcessos ${@: -1}