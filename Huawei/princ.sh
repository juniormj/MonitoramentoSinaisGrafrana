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


influx -execute "drop database sinais"
influx -execute "create database sinais"

cd /home/grafanapa/Scripts/Huawei/

for i in `cat IPs`
do
    ./principal.sh $i
    sleep 30
done
