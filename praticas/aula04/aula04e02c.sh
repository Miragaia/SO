#!/bin/bash
echo "enter the numbers: "
read a;
read b;
echo "a= $a";
echo "b= $b";
function comparar(){
    if [ $a -eq $b ]
    then
        echo "iguais";
    else
        if [ $a -gt $b ]
        then
            echo $a;
        else 
            echo $b;
        fi
    fi
}

comparar