#!/bin/bash

n1=1 ; n2=1 ; n3=1

if [ "$USER" = "root" ]; then
	user=$SUDO_USER
else
	user=$USER
fi

pasta_conficuracao=/home/$user/.Agendador
pasta_aplicacoes=/usr/share/Agendador

nome="d m a"
for i in $nome
do
	if ! [ -e "$pasta_conficuracao/test$i.conf" ]; then
		echo "0" > $pasta_conficuracao/test$i.conf
	fi
	
	if ! [ -e "$pasta_conficuracao/agendamentos$i.conf" ]; then
		touch $pasta_conficuracao/agendamentos$i.conf
	fi
	
	if ! [ -e "$pasta_conficuracao/removidos$i.conf" ]; then
		touch $pasta_conficuracao/removidos$i.conf
	fi
	if ! [ -e "$pasta_conficuracao/descricao$i.conf" ]; then
		touch $pasta_conficuracao/descricao$i.conf
	fi
done

chmod 664 $pasta_conficuracao/*.conf
chown $user:$user $pasta_conficuracao/*.conf

tempo_principal(){
	configuracao="$1" ; ka=("$2" "$3" "$4" "$5" "$6") ; nk="$7"
	minutok=$(echo -e "$configuracao" | sed -n "$nk,$nk p" | cut -d ":" ${ka[0]})
	horak=$(echo -e "$configuracao" | sed -n "$nk,$nk p" | cut -d ":" ${ka[1]})
	tempok="${horak:1:2}:${minutok:0:2}"
	semanak=$(echo -e "$configuracao" | sed -n "$nk,$nk p" | cut -d ":" ${ka[2]})
	semanak=$(echo -e "$semanak" | cut -d "H" -f1)
	if [ "${#semanak}" != "0" ]; then
		semanak=$(echo "${semanak:1:$[${#semanak} - 4]}")
	fi
	mesek=$(echo -e "$configuracao" | sed -n "$nk,$nk p" | cut -d ":" ${ka[3]})
	mesek=$(echo -e "$mesek" | cut -d "D" -f1)
	if [ "${#mesek}" != "0" ]; then
		mesek=$(echo "${mesek:1:$[${#mesek} - 4]}")
	fi
	anok=$(echo -e "$configuracao" | sed -n "$nk,$nk p" | cut -d ":" ${ka[4]})
	anok=$(echo -e "$anok" | cut -d "M" -f1)
	if [ "${#anok}" != "0" ]; then
		anok=$(echo "${anok:1:$[${#anok} - 4]}")
	fi
}

ativador_principal(){
	ano2=$1 ; mes2=$2 ; seman=$3 ; dia1=$4 ; n_1=$5 ; tempo2=$6
	teste=$7 ; n=$8
	ano=$(date +%Y) ; mes=$(date +%b) ; tempo=$(date +%R)
	for i in $ano2
		do
			case $ano in
				$i)
				for j in $mes2
				do
					case $mes in 
						$j)
						for k in $seman
						do
							case $dia1 in 
								$k)
								if [ "$tempo" = "$tempo2" ]; then
									contador=$(cat $pasta_conficuracao/$teste)
									contador=$(echo $contador | tr '\n' ' ')
									var=1
									for i in $contador
									do
										if [ $i -eq $n ]; then
											var=0
										fi
									done
									if [ $var -eq 1 ]; then 
										echo "$n" >> $pasta_conficuracao/$teste
										sed '/^$/d' $pasta_conficuracao/$teste > $pasta_conficuracao/temp.conf
										mv $pasta_conficuracao/temp.conf $pasta_conficuracao/$teste
										chown $user:$user $pasta_conficuracao/$teste
										chmod 664 $pasta_conficuracao/$teste
										roxterm -e "$pasta_aplicacoes/mostrador.sh $n_1 $n" &
										sleep 1
									fi
								fi
								;;
							esac
						done
						;;
					esac
				done
				;;
			esac
		done
}

while true
do	
	diaconfiguracao="$(cat $pasta_conficuracao/agendamentosd.conf)"
	mesconfiguracao="$(cat $pasta_conficuracao/agendamentosm.conf)"
	anoconfiguracao="$(cat $pasta_conficuracao/agendamentosa.conf)"
	test1=${#diaconfiguracao} ; test2=${#mesconfiguracao}
	test3=${#anoconfiguracao}
	if [ $test1 -ne 0 ]; then
		cont=$(echo -e "$diaconfiguracao" | cut -d "-" -f1)
		test1_num=1
		for i in $cont
		do
			if [  $i -ge $test1_num ]; then
				cont=$i
			fi
		done
	else
		cont=0
	fi
	if [ $test2 -ne 0 ]; then
		cont1=$(echo -e "$mesconfiguracao" | cut -d "-" -f1)
		test1_num=1
		for i in $cont1
		do
			if [  $i -ge $test1_num ]; then
				cont1=$i
			fi
		done
	else
		cont1=0
	fi
	if [ $test3 -ne 0 ]; then
		cont2=$(echo -e "$anoconfiguracao" | cut -d "-" -f1)
		test1_num=1
		for i in $cont2
		do
			if [  $i -ge $test1_num ]; then
				cont2=$i
			fi
		done
	else
		cont2=0
	fi
	sem=$(date +%a) ; dia_d=$(date +%d) 
	for i in $nome
	do
		removido=$(cat $pasta_conficuracao/removidos$i.conf)
		linha=$(wc -l $pasta_conficuracao/test$i.conf | cut -d " " -f1)
		for j in $removido
		do
			q=2
			while true
			do 
				k=$(sed -n "$q,$q p" $pasta_conficuracao/test$i.conf)
				if [ "$k" = "$j" ]; then
					sed "$q d" $pasta_conficuracao/test$i.conf > \
					$pasta_conficuracao/temp.conf
					mv $pasta_conficuracao/temp.conf $pasta_conficuracao/test$i.conf
					sed '/^$/d' $pasta_conficuracao/test$i.conf > \
					$pasta_conficuracao/temp.conf 
					mv $pasta_conficuracao/temp.conf $pasta_conficuracao/test$i.conf
					chown $user:$user $pasta_conficuracao/test$i.conf
					chmod 664 $pasta_conficuracao/test$i.conf
				fi
				if [ $q -ge $linha ]; then
					break
				fi
				q=$[q + 1]
			done
		done
		echo "0" > $pasta_conficuracao/removidos$i.conf
	done
	if [ "$tempo" = "00:00" ]; then
		for i in $nome
		do
			echo "0" > $pasta_conficuracao/test$i.conf
		done
	fi
	if [ $cont -ne 0 ]; then
		if [ $n1 -ge $cont ]; then
			n1=1
		else
			n1=$[ n1 + 1 ]
		fi
		tempo_principal "$diaconfiguracao" "-f5" "-f4" "-f3" "-f2" "-f1" "$n1"
		ativador_principal "$ano" "$mes" "$semanak" "$sem" "1" "$tempok" "testd.conf" "$n1"
	fi
	if [ $cont1 -ne 0 ]; then
		if [ $n2 -ge $cont1 ]; then
			n2=1
		else
			n2=$[ n2 + 1 ]
		fi
		tempo_principal "$mesconfiguracao" "-f6" "-f5" "-f4" "-f3" "-f2" "$n2"
		ativador_principal "$ano" "$mesek" "$semanak" "$dia_d" "2" "$tempok" "testm.conf" "$n2"
	fi
	if [ $cont2 -ne 0 ]; then
		if [ $n3 -ge $cont2 ]; then
			n3=1
		else
			n3=$[ n3 + 1 ]
		fi
		tempo_principal "$anoconfiguracao" "-f7" "-f6" "-f5" "-f4" "-f3" "$n3"
		ativador_principal "$anok" "$mesek" "$semanak" "$dia_d" "3" "$tempok" "testa.conf" "$n3"
	fi
	sleep 1.5
done

exit 0
