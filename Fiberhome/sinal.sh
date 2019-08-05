#!/bin/bash

########################################################################
#      Sistema utilizado para coleta de informacoes de sinais via SNMP 
# O script sera responsavel pela coleta de sinais alto na(s) OLT(s).
#
########################################################################

########################################################################
# Recebe parametro vindo principal.sh
########################################################################
IP=$1
cidade=$2

########################################################################
# Essa funcao e responsavel por obter os sinal das ONUs.
# E realizado um for no arquivo ID onde contem todos os index gerado pelo
# SNMP.
########################################################################
function verifica_sinal() {
    rm qnt
    for linha in `cat ID`
    do
        FHTT=$(cat Mac | grep $linha | awk '{print $4}' | sed 's/\"//'g)
        SINAL=$(cat sinal | grep $linha | awk '{print $4}' | sed 's/\(...\)\(.*\)/\1.\2/g')
        SLOTP=$(cat SlotPon | grep $linha | awk '{print $5}' | sed 's/\"//')

        echo $SINAL

        if (( $(echo "$SINAL < -24.00" | bc -l) )); then
            echo $linha >> qnt
            curl -s -X POST https://api.telegram.org/bot<TOKEN>/sendMessage -d chat_id=<CHAT_ID> -d text="$SLOTP; $FHTT; $SINAL de $cidade"
            influx -execute "insert $cidade onu=\"$SLOTP\",sinal=\"$SINAL\",ip=\"$IP\"" -database="sinais_fiberhome"
	fi
   done
   qnt=$((`cat qnt | awk 'NF>0' | wc -l`))
   curl -s -X POST POST https://api.telegram.org/bot<TOKEN>/sendMessage -d chat_id=<CHAT_ID> -d text="Encontradas $qnt onus anormais em $cidade"
   rm ID
   rm Mac
   rm onuStatus
   rm sinal
   rm SlotPon

}

verifica_sinal
