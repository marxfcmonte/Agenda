#!/bin/bash

if [ "$USER" = "root" ]; then
	user=$SUDO_USER
else
	user=$USER
fi

pasta_conficuracao=/home/$user/.Agendador

imprime_agendamento(){
	p=$1 ; q=$2 ; r=$3
	n=$(cat $pasta_conficuracao/agenda$p.conf)
	titulo="TAREFA AGENDADA - $r"
	texto=$(echo -e "$(cat $pasta_conficuracao/descricao$q.conf)" | sed -n "$n,$n p")
	cont2="$[${#texto} + 4]"
	cont1="$[${#titulo} + 4]"
	if [ $cont1 -ge $cont2 ]; then
		cont=$cont1
	else
		cont=$cont2
	fi
	retorno=("$titulo" "$texto" "$cont")
}

agenda=$(cat $pasta_conficuracao/agenda.conf)
case $agenda in 
	1) imprime_agendamento "dia" "d" "SEMANAL" ;;
	2) imprime_agendamento "mes" "m" "MENSAL" ;;
	3) imprime_agendamento "ano" "a" "ANUAL" ;;
esac

dialog --colors --title "\Zr\Z1  ${retorno[0]}                          
              \Zn" --msgbox "${retorno[1]}" 6 ${retorno[2]} 
clear

exit 0
