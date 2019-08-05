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

IP=$1
echo $IP

if [ "$IP" == "xxx.xx.x.xx" ]; then
    cidade="nome_da_cidade"

fi

function main() {
    criaMac
    criaOnuStatus
    criaSinal
    criaSlotPon
    criaID
    ./sinal.sh $IP $cidade
}

function criaMac() {
    snmpwalk -v2c -c adsl $IP authOnuListMac > Mac
}

function criaOnuStatus() {
    snmpwalk -v2c -c adsl $IP onuStatus > onuStatus
}

function criaSinal() {
    snmpwalk -v2c -c adsl $IP onuPonRxOpticalPower > sinal
}

function criaSlotPon() {
    snmpwalk -v2c -c adsl $IP onuPonName > SlotPon
}

function criaID() {
    cat Mac | cut -d "." -f2 | awk '{print $1}' > ID
}

main
