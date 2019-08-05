#!/bin/bash
########################################################################
# O script inicia deletando um banco, caso exista e recriando-o.
########################################################################

influx -execute "drop database sinais_fiberhome"
influx -execute "create database sinais_fiberhome"

cd /home/usuario/Scripts/Fiberhome/

for i in `cat IPs`
do
    ./principal.sh $i
    sleep 30
done
