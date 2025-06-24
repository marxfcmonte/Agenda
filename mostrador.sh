#!/bin/bash

agenda="$1"
n="$2"

if [ "$USER" = "root" ]; then
	user=$SUDO_USER
else
	user=$USER
fi

pasta_conficuracao=/home/$user/.Agendador

imprime_agendamento(){
	q=$1 ; r=$2
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

case $agenda in 
	1) imprime_agendamento "d" "SEMANAL" ;;
	2) imprime_agendamento "m" "MENSAL" ;;
	3) imprime_agendamento "a" "ANUAL" ;;
esac

dialog --colors --title "\Zr\Z1  ${retorno[0]}                          
              \Zn" --msgbox "${retorno[1]}" 6 ${retorno[2]} 
clear
exit 0
