#!/bin/bash

########################################################################
# Autor: Messias Manoel da Silva Junior:             juniormj1@gmail.com
# Part.: Jenilson                                  jenilsonpcj@gmail.com
# Data Criacao:                                    25 de Outubro de 2018
# info: Script utilizado para coletar informacoes de sinais anormais.
# modo de usar: para utilizar esse script devera ser chamado passando o
#               IP da OLT. Exemp.: ./principal.sh x.x.x.x
# Changelog:
# 02-01-2019 - Declarar nome aos IPs da OLT
# 02-01-2019 - Criado um arquivo IPs com todos IPs da OLT
# 05-01-2019 - Adicionado a contagem de ONUs anormais
########################################################################


# Recebe IP
IP=$1
echo $IP

if [ "$IP" == "xxx.xx.x.xx" ]; then
    cidade="nome_da_cidade"

fi

function main() {
    criaSinal
    criaSlotPon
    ./sinal.sh $IP $cidade
}


function criaSinal() {
    snmpwalk -v2c -c public $IP 1.3.6.1.4.1.2011.6.128.1.1.2.51.1.4 > sinal
}

function criaSlotPon() {
    snmpwalk -v2c -c public $IP ifName > SlotPon-H
    cat sinal | sed 's/SNMPv2-SMI::enterprises.2011.6.128.1.1.2.51.1.4.//' | awk '{print $1}' > SPID
}

main
