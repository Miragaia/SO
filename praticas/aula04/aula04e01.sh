#!/bin/bash
function imprime_msg()
{
    echo "A minha primeira funcao"
    return 0
}
function data()
{
    echo $(date)
    return 0
}

function dados()
{
    echo $USER
    echo $(hostname)
    return 0
}

imprime_msg
data
dados