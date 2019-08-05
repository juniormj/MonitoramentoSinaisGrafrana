#!/bin/bash
########################################################################
# Messias Manoel da Silva Junior:                    juniormj1@gmail.com
# Participacao: Jenilson          -          jenilson@ateltelecom.com.br
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
cidade=$2


function verifica_sinal() {
    rm qnt
    for linha in `cat SPID`
    do
        PNST=$(echo $linha | cut -d. -f1)
        SINAL=$(cat sinal | grep $linha | awk '{print $4}' | sed 's/\(...\)\(.*\)/\1.\2/g')
        SLOTP=$(cat SlotPon-H | grep $PNST | cut -d. -f2 | awk '{print $5}' | sed 's/0\///')

        if (( $(echo "$SINAL < -24.00" | bc -l) )); then
             echo $linha >> qnt
             ID=$(echo $linha | cut -d. -f2)
             curl -s -X POST https://api.telegram.org/bot<TOKEN>/sendMessage -d chat_id=<CHAT_ID> -d text="$SLOTP/$ID; $SINAL de $cidade"
             influx -execute "insert $cidade onu=\"$SLOTP/$ID\",sinal=\"$SINAL\",ip=\"$IP\"" -database="sinais"
        fi
    done
    qnt=$((`cat qnt | awk 'NF>0' | wc -l`))
    curl -s -X POST https://api.telegram.org/bot<TOKEN>/sendMessage -d chat_id=<CHAT_ID> -d text="Encontradas $qnt onus anormais em $cidade"
    rm SPID
    rm sinal
    rm SlotPon-H
}

verifica_sinal
