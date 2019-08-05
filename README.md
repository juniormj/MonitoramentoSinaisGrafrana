# Monitoramento Sinais integrado com Grafrana

Esse script visa monitorar sinais que ultrapassem o aceitável -23dB, percorre toda a OLT varrendo PON por PON e verificando o sinal
de cada ONU.

Caso entro os fora do padrão ele dispara um alerta de notificação para o telegram com as seguintes informações:

FIBERHOME:
* ONUID/PON/SLOT
* FHTT
* SINAL
* CIDADE

HUAWEI:
* ONUID/PON/SLOT
* SINAL
* CIDADE

E no final ele armazena num banco de dados InfluxDB e com grafana gera tabelas de sinais passados fora do padrão.
O Script está configurado para pegar valores que passem de -24dB, caso queiram alterar esse valor ir na linha 35
do arquivo sinal.sh
