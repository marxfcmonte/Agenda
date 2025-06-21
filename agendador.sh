#!/bin/bash

if [ "$USER" = "root" ]; then
	user=$SUDO_USER
else
	user=$USER
fi

pasta_conficuracao=/home/$user/.Agendador

erro_principal(){
	clear ; texto=$1 ; cont=$[${#texto} + 4]
	dialog --colors --title "\Zr\Z1  ERRO                
				\Zn" --infobox "$texto" 3 $cont
	sleep 1.5
	clear
}

display_principal(){
	titulo=$1 ; texto=$2 ; clear ; cont=$[${#texto} + 4]
	dialog --colors --title "$titulo" --infobox "$texto" 3 $cont ; sleep 2
	clear	
}

cadastro_principal(){ 
	hora="00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23"
	minuto="00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 \
24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 \
48 49 50 51 52 53 54 55 56 57 58 59"
	descricao=$(dialog --title "Descrição" --inputbox "Nome do agendamento: " 0 0 \
--stdout) 
	if [ "$?" = "0" ]; then 
		while true
		do	
			tempoh=$(dialog --title "Tempo da hora" --inputbox "Informe a hora [00 a 23]: " 8 29 \
--stdout) 
			if [ "$?" = "0" ]; then
				for j in $hora
				do
					if [ "$tempoh" = "$j" ]; then
						teste=0 ; break
					else
						teste=1
					fi
				done
				if [ $teste -eq 1 ]; then
					erro_principal "HORA INVÁLIDA!"
				else
					break
				fi
			else
				clear ; agendamento_principal ; break
			fi
		done
		while true
		do	
			tempom=$(dialog --title "Tempo do minuto" --inputbox "Informe a minuto [00 a 59]: " 8 32 \
--stdout)
			if [ "$?" = "0" ]; then
				for j in $minuto
				do
					if [ "$tempom" = "$j" ]; then
						teste=0 ; break
					else
						teste=1
					fi
				done
				if [ $teste -eq 1 ]; then
					erro_principal "MINUTO INVÁLIDO!"
				else
					break
				fi 
			else
				clear ; agendamento_principal ; break
			fi
		done
	else
		agendamento_principal
	fi
}

semana_principal(){
	dia=$(date +%a)
	case $dia in
		"seg") estado=("ON" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"ter") estado=("OFF" "ON" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"qua") estado=("OFF" "OFF" "ON" "OFF" "OFF" "OFF" "OFF") ;;
		"qui") estado=("OFF" "OFF" "OFF" "ON" "OFF" "OFF" "OFF") ;;
		"sex") estado=("OFF" "OFF" "OFF" "OFF" "ON" "OFF" "OFF") ;;
		"sáb") estado=("OFF" "OFF" "OFF" "OFF" "OFF" "ON" "OFF") ;;
		"dom") estado=("OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "ON") ;;
	esac
	opcao2=$(dialog --no-cancel --title "MENU - DIAS DA SEMANA" --checklist \
"Qual dos dias da semana serão habilitados?" 14 47 7 \
"seg" "Segunda-feira" ${estado[0]} \
"ter" "Terça-feira" ${estado[1]} \
"qua" "Quarta-feira" ${estado[2]} \
"qui" "Quinta-feira" ${estado[3]} \
"sex" "Sexta-feira" ${estado[4]} \
"sáb" "Sábado" ${estado[5]} \
"dom" "Domingo" ${estado[6]} \
--stdout)
}

dia_principal(){
	dia_num=$1 ; caso=$2 ; dia_hoje=$(date +%d)	
	case $caso in 
		1) texto1="[01 a 31]" ;;
		2) texto1="[01 a 30]" ;;
		3)
		case $dia_bi in 
			0) texto1="[01 a 29]" ;;
			1) texto1="[01 a 28]" ;;
		esac
		;;
	esac
	while true
	do
		texto="Informe o dia do(s) mês(s) $opcao3 [$dia_hoje]" ; cont=$[${#texto} + 1]
		dia_mes=$(dialog --title "$texto" --inputbox "Informe o dia $texto1: " 8 $cont \
--stdout) 
		if [ "$?" = "0" ]; then
			if [ "$dia_mes" ]; then
				for j in $dia_num
				do
					if [ "$dia_mes" = "$j" ]; then
						teste=0 ; break
					else
						teste=1
					fi
				done
				if [ $teste -eq 1 ]; then
					erro_principal "DIA INVÁLIDO!"
				else
					break
				fi
			else
				clear ; dia_mes=$dia_hoje ; break
			fi
		else
			clear ; agendamento_principal ; break
		fi
	done
	
}

mes_principal(){
	mes=$(date +%b)
	case $mes in
		"jan") estado1=("ON" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"fev") estado1=("OFF" "ON" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"mar") estado1=("OFF" "OFF" "ON" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"abr") estado1=("OFF" "OFF" "OFF" "ON" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"mai") estado1=("OFF" "OFF" "OFF" "OFF" "ON" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"jun") estado1=("OFF" "OFF" "OFF" "OFF" "OFF" "ON" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"jul") estado1=("OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "ON" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"ago") estado1=("OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "ON" "OFF" "OFF" "OFF" "OFF") ;;
		"set") estado1=("OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "ON" "OFF" "OFF" "OFF") ;;
		"out") estado1=("OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "ON" "OFF" "OFF") ;;
		"nov") estado1=("OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "ON" "OFF") ;;
		"dez") estado1=("OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "ON") ;;
	esac
	dia1="01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 \
24 25 26 27 26 29 30 31"
	dia2="01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 \
24 25 26 27 26 29 30"
	dia3="01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 \
24 25 26 27 28 29"
	dia4="01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 \
24 25 26 27 28"
	ano=$(date +%Y) ; resto=$[ano % 4] ; resto1=$[ano % 100] ; resto2=$[ano % 400]
	if [ $resto -eq 0 ]; then
		if [ $resto1 -ne 0 ]; then
			diab=$dia3 ; dia_bi=0
		else
			if [ $resto2 -eq 0 ]; then
				diab=$dia3 ; dia_bi=0
			else
				diab=$dia4 ; dia_bi=1
			fi
		fi
	else
		diab=$dia4 ; dia_bi=1
	fi
	opcao3=$(dialog --no-cancel --title "MENU - MESES D0 ANO" --checklist \
"Qual dos meses serão habilitados?" 19 38 12 \
"jan" "Janeiro" ${estado1[0]} \
"fev" "Fevereiro" ${estado1[1]} \
"mar" "Março" ${estado1[2]} \
"abr" "Abril" ${estado1[3]} \
"mai" "Maio" ${estado1[4]} \
"jun" "Junho" ${estado1[5]} \
"jul" "Julho" ${estado1[6]} \
"ago" "Agosto" ${estado1[7]} \
"set" "Setembro" ${estado1[8]} \
"out" "Outubro" ${estado1[9]} \
"nov" "Novembro" ${estado1[10]} \
"dez" "Dezembro" ${estado1[11]} \
--stdout)
	clear
	for i in $opcao3 
	do
		case $i in
			"fev") dia_principal "$diab" "3" ; break ;;
			"abr"|"jun"|"set"|"nov") 
			teste=0
			for j in $opcao3 
			do
				case $j in
					"fev") dia_principal "$diab" "3" ; teste=1 ; break ;;
				esac
			done
			if [ $teste -eq 1 ]; then
				break
			fi
			dia_principal "$dia2" "2" ; break ;;
			"jan"|"mar"|"mai"|"jul"|"ago"|"out"|"dez") 
			teste=0
			for j in $opcao3 
			do
				case $j in
					"fev") dia_principal "$diab" "3" ; teste=1 ; break ;;
				esac
			done
			if [ $teste -eq 1 ]; then
				break
			fi
			teste=0
			for j in $opcao3 
			do
				case $j in
					"abr"|"jun"|"set"|"nov")
					dia_principal "$dia2" "2" ; teste=1 ; break ;;
				esac
			done
			if [ $teste -eq 1 ]; then
				break
			fi
			dia_principal "$dia1" "1" ; break ;;
		esac
	done
}

ano_principal(){
	ano=$(date +%Y)
	case $ano in
		"2025") estado2=("ON" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"2026") estado2=("OFF" "ON" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"2027") estado2=("OFF" "OFF" "ON" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"2028") estado2=("OFF" "OFF" "OFF" "ON" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"2029") estado2=("OFF" "OFF" "OFF" "OFF" "ON" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"2030") estado2=("OFF" "OFF" "OFF" "OFF" "OFF" "ON" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"2031") estado2=("OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "ON" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"2032") estado2=("OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "ON" "OFF" "OFF" "OFF" "OFF") ;;
		"2033") estado2=("OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "ON" "OFF" "OFF" "OFF") ;;
		"2034") estado2=("OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "ON" "OFF" "OFF") ;;
		"2035") estado2=("OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "ON" "OFF") ;;
		"2036") estado2=("OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "ON") ;;
	esac
	opcao4=$(dialog --no-cancel --title "MENU - ANOS DE 2025 A 2036" --checklist \
"Qual dos anos serão habilitados?" 19 37 12 \
"2025" "Ano 2025" ${estado2[0]} \
"2026" "Ano 2026" ${estado2[1]} \
"2027" "Ano 2027" ${estado2[2]} \
"2028" "Ano 2028" ${estado2[3]} \
"2029" "Ano 2029" ${estado2[4]} \
"2030" "Ano 2030" ${estado2[5]} \
"2031" "Ano 2031" ${estado2[6]} \
"2032" "Ano 2032" ${estado2[7]} \
"2033" "Ano 2033" ${estado2[8]} \
"2034" "Ano 2034" ${estado2[9]} \
"2035" "Ano 2035" ${estado2[10]} \
"2036" "Ano 2036" ${estado2[11]} \
--stdout)
}

sem_compromisso(){
	termo=$1
	dialog --nocancel --title "SEM AGENDAMENTOS $termo" --msgbox "Sem Compromissos agendados." 5 31
}

agendamento_secundario(){
	clear
	opcao1=$(dialog --title "MENU" --menu \
"Qual opção vai escolher?" 10 30 3 \
"1" "Menu de agendamentos" \
"2" "Menu principal" \
"3" "Sair" \
--stdout)
	clear
	case $opcao1 in
		1) agendamento_principal ;;
		2) menu_principal ;;
		3) sair ;;
		*) cancelar ;;
	esac
}

remover_secundario(){
	clear
	opcao1=$(dialog --title "MENU" --menu \
"Qual opção vai escolher?" 10 41 3 \
"1" "Menu de remoção de agendamentos" \
"2" "Menu principal" \
"3" "Sair" \
--stdout)
	clear
	case $opcao1 in
		1) remover_principal ;;
		2) menu_principal ;;
		3) sair ;;
		*) cancelar ;;
	esac
}

listar_secundario(){
	clear
	opcao1=$(dialog --title "MENU" --menu \
"Qual opção vai escolher?" 10 37 3 \
"1" "Menu de listar agendamentos" \
"2" "Menu principal" \
"3" "Sair" \
--stdout)
	clear
	case $opcao1 in
		1) listar_principal ;;
		2) menu_principal ;;
		3) sair ;;
		*) cancelar ;;
	esac
}

arquivo_organizacao(){
	d="$1" ; text_r="" ; text_r_1="" ; text_d="" ; text_d_1=""
	maior=$(cat $pasta_conficuracao/agendamentos$d.conf | cut -d "-" -f1)
	tamanho=$(wc -l $pasta_conficuracao/agendamentos$d.conf | cut -d " " -f1)
	if [ "$tamanho" = "0" ]; then
		maior=1
	fi
	maior="$(echo "$maior" | tr '\n' ' ')"
	comp=1
	for i in $maior
	do
		if [ $i -ge $comp ]; then
			comp=$i
		fi
	done
	maior=$comp
	for i in $(seq 1 $maior)
	do
		contad=$(sed -n "$i,$i p" $pasta_conficuracao/agendamentos$d.conf | cut -d "-" -f1)
		if [ "$contad" != "$i " ]; then 
			num="$i"
			if [ "$num" = "1" -a "$tamanho" != "0" ]; then
				text_r="0"
				text_r_1=$(sed -n "1,$maior p" $pasta_conficuracao/agendamentos$d.conf)
				text_d="0"
				text_d_1=$(sed -n "1,$maior p" $pasta_conficuracao/descricao$d.conf)
			elif [ "$tamanho" = "0" ]; then
				text_r="0"
				text_d="0"
			else
				text_r=$(sed -n "1,$[i-1] p" $pasta_conficuracao/agendamentos$d.conf)
				text_r_1=$(sed -n "$i,$tamanho p" $pasta_conficuracao/agendamentos$d.conf)
				text_d=$(sed -n "1,$[i-1] p" $pasta_conficuracao/descricao$d.conf)
				text_d_1=$(sed -n "$i,$tamanho p" $pasta_conficuracao/descricao$d.conf)
			fi
			break
		else
			text_r=$(sed -n "1,$maior p" $pasta_conficuracao/agendamentos$d.conf)
			text_d=$(sed -n "1,$maior p" $pasta_conficuracao/descricao$d.conf)
			num="$[maior + 1]"
		fi
	done
	retorno=("$num" "$text_r" "$text_r_1" "$text_d" "$text_d_1")
}

imprime_agendamento(){
	num=$1 ; d=$2 ; titulo=$3
	clear
	texto="$(sed -n "$num,$num p" $pasta_conficuracao/agendamentos$d.conf | cut -d ":" -f1): \
$(sed -n "$num,$num p" $pasta_conficuracao/descricao$d.conf) \
$(sed -n "$num,$num p" $pasta_conficuracao/agendamentos$d.conf | cut -d "|" -f2)"
	dialog --nocancel --title "AGENDAMENTO $titulo" --msgbox "$texto" 0 0
}

agendamento_principal(){
	opcao1=$(dialog --title "MENU - TIPOS DE AGENDAMEBTOS" --menu \
"Qual tipo de agendamento que deseja?" 12 40 5 \
"1" "Agendamentos semanais" \
"2" "Agendamentos mensais" \
"3" "Agendamentos anuais" \
"4" "Menu principal" \
"5" "Sair" \
--stdout)
	case $opcao1 in
		1) 
		arquivo_organizacao "d"
		num1=${retorno[0]} ; text_res=${retorno[1]} ; text_res_1=${retorno[2]} 
		text_des=${retorno[3]} ; text_des_1=${retorno[4]}
		cadastro_principal ; semana_principal ; teste=0 ; k=""
		for i in $opcao2
		do	
			if [ "$teste" -eq 0 ]; then
				k="$i " ; semana="$k" ; teste=1
			else
				semana="$k$i " ; k="$k$i "
			fi
		done
		if [ "${#semana}" != "0" ]; then
			semana=${semana:0:$[${#semana} - 1]}
		fi
		if [ "$text_res" != "0" ]; then
			echo "$text_res" > $pasta_conficuracao/agendamentosd.conf
			echo "$num1 - Descrição: | * Dia(s) da semana: $semana * Horário: $tempoh:$tempom" >> \
			$pasta_conficuracao/agendamentosd.conf
			echo "$text_res_1" >> $pasta_conficuracao/agendamentosd.conf
		else
			echo "$num1 - Descrição: | * Dia(s) da semana: $semana * Horário: $tempoh:$tempom" > \
			$pasta_conficuracao/agendamentosd.conf
			echo "$text_res_1" >> $pasta_conficuracao/agendamentosd.conf
		fi
		if [ "$text_des" != "0" ]; then
			echo "$text_des" > $pasta_conficuracao/descricaod.conf
			echo "$descricao" >> $pasta_conficuracao/descricaod.conf
			echo "$text_des_1" >> $pasta_conficuracao/descricaod.conf
		else
			echo "$descricao" > $pasta_conficuracao/descricaod.conf
			echo "$text_des_1" >> $pasta_conficuracao/descricaod.conf
		fi
		sed '/^$/d' $pasta_conficuracao/agendamentosd.conf > \
		$pasta_conficuracao/temp.conf && mv $pasta_conficuracao/temp.conf $pasta_conficuracao/agendamentosd.conf
		sed '/^$/d' $pasta_conficuracao/descricaod.conf > \
		$pasta_conficuracao/temp.conf && mv $pasta_conficuracao/temp.conf $pasta_conficuracao/descricaod.conf
		imprime_agendamento "$num1" "d" "SEMANAL" ; agendamento_secundario ;;
		2)
		arquivo_organizacao "m"
		num2=${retorno[0]} ; text_res1=${retorno[1]} ; text_res1_1=${retorno[2]} 
		text_des1=${retorno[3]} ; text_des1_1=${retorno[4]}
		cadastro_principal ; mes_principal ; semana=$dia_mes ; teste=0 ; k=""
		for i in $opcao3
		do	
			if [ "$teste" -eq 0 ]; then
				k="$i " ; meses="$k" ; teste=1
			else
				meses="$k$i " ; k="$k$i "
			fi
		done
		if [ "${#meses}" != "0" ]; then
			meses=${meses:0:$[${#meses} - 1]}
		fi
		if [ "$text_res1" != "0" ]; then
			echo "$text_res1" > $pasta_conficuracao/agendamentosm.conf
			echo "$num2 - Descrição: | * Mes(es) do ano: $meses * Dia do(s) Mes(es): $semana * Horário: $tempoh:$tempom" >> \
			$pasta_conficuracao/agendamentosm.conf
			echo "$text_res1_1" >> $pasta_conficuracao/agendamentosm.conf
		else
			echo "$num2 - Descrição: | * Mes(es) do ano: $meses * Dia do(s) Mes(es): $semana * Horário: $tempoh:$tempom" > \
			$pasta_conficuracao/agendamentosm.conf
			echo "$text_res1_1" >> $pasta_conficuracao/agendamentosm.conf
		fi
		if [ "$text_des1" != "0" ]; then
			echo "$text_des1" > $pasta_conficuracao/descricaom.conf 
			echo "$descricao" >> $pasta_conficuracao/descricaom.conf
			echo "$text_des1_1" >> $pasta_conficuracao/descricaom.conf
		else
			echo "$descricao" > $pasta_conficuracao/descricaom.conf
			echo "$text_des1_1" >> $pasta_conficuracao/descricaom.conf
		fi
		sed '/^$/d' $pasta_conficuracao/agendamentosm.conf > \
		$pasta_conficuracao/temp.conf && mv $pasta_conficuracao/temp.conf $pasta_conficuracao/agendamentosm.conf
		sed '/^$/d' $pasta_conficuracao/descricaom.conf > \
		$pasta_conficuracao/temp.conf && mv $pasta_conficuracao/temp.conf $pasta_conficuracao/descricaom.conf
		imprime_agendamento "$num2" "m" "MENSAL" ; agendamento_secundario ;;
		3) 
		arquivo_organizacao "a"
		num3=${retorno[0]} ; text_res2=${retorno[1]} ; text_res2_1=${retorno[2]} 
		text_des2=${retorno[3]} ; text_des2_1=${retorno[4]}
		cadastro_principal ; mes_principal ; ano_principal ; semana=$dia_mes
		teste=0 ; k=""
		for i in $opcao3
		do	
			if [ "$teste" -eq 0 ]; then
				k="$i " ; meses="$k" ; teste=1
			else
				meses="$k$i " ; k="$k$i "
			fi
		done
		teste=0 ; k=""
		for i in $opcao4
		do	
			if [ "$teste" -eq 0 ]; then
				k="$i " ; anos="$k" ; teste=1
			else
				anos="$k$i " ; k="$k$i "
			fi
		done
		if [ "${#meses}" != "0" ]; then
			meses=${meses:0:$[${#meses} - 1]}
		fi
		if [ "${#anos}" != "0" ]; then
			anos=${anos:0:$[${#anos} - 1]}
		fi
		if [ "$text_res2" != "0" ]; then
			echo "$text_res2" > $pasta_conficuracao/agendamentosa.conf
			echo "$num3 - Descrição: | * Ano(s): $anos * Mes(es) do ano: $meses * Dia do(s) mes(es): $semana * Horário: $tempoh:$tempom" >> \
			$pasta_conficuracao/agendamentosa.conf
			echo "$text_res2_1" >> $pasta_conficuracao/agendamentosa.conf
		else
			echo "$num3 - Descrição: | * Ano(s): $anos * Mes(es) do ano: $meses * Dia do(s) mes(es): $semana * Horário: $tempoh:$tempom" > \
			$pasta_conficuracao/agendamentosa.conf
			echo "$text_res2_1" >> $pasta_conficuracao/agendamentosa.conf
		fi
		if [ "$text_des2" != "0" ]; then
			echo "$text_des2" > $pasta_conficuracao/descricaoa.conf
			echo "$descricao" >> $pasta_conficuracao/descricaoa.conf
			echo "$text_des2_1" >> $pasta_conficuracao/descricaoa.conf
		else
			echo "$descricao" > $pasta_conficuracao/descricaoa.conf
			echo "$text_des2_1" >> $pasta_conficuracao/descricaoa.conf
		fi
		sed '/^$/d' $pasta_conficuracao/agendamentosa.conf > \
		$pasta_conficuracao/temp.conf && mv $pasta_conficuracao/temp.conf $pasta_conficuracao/agendamentosa.conf
		sed '/^$/d' $pasta_conficuracao/descricaoa.conf > \
		$pasta_conficuracao/temp.conf && mv $pasta_conficuracao/temp.conf $pasta_conficuracao/descricaoa.conf
		imprime_agendamento "$num3" "a" "ANUAL" ; agendamento_secundario ;;
		4) menu_principal ;;
		5) sair ;;
		*) cancelar ;;
	esac
}

remover_lista(){
	nome_termo=$1 ; d=$2
	con=$(wc -l $pasta_conficuracao/agendamentos$d.conf | cut -d " " -f1)
	while true
	do
		if [ "$con" != "0" ]; then 
			res=$(dialog --title "AGENDAMENTOS $nome_termo" --keep-window --begin 0 0 --msgbox "$(
i=1
tot=$(wc -l $pasta_conficuracao/agendamentos$d.conf | cut -d " " -f1)
while true
do 
	a=$(sed -n "$i,$i p" $pasta_conficuracao/agendamentos$d.conf | cut -d ":" -f1) 
	b=$(sed -n "$i,$i p" $pasta_conficuracao/descricao$d.conf)
	c=$(sed -n "$i,$i p" $pasta_conficuracao/agendamentos$d.conf | cut -d '|' -f2)
	echo -e "$a: $b $c\n"
	if [ $i -eq  $tot ]; then
		break
	fi
	i=$[i+1]
done)"  0 0 \
--and-widget --keep-window --begin 13 44 --help-button --inputbox "Informe os agendamentos para remover:" 0 0 --stdout) 
			var="$?"
			if [ "$var" = "2" ]; then
				dialog --title "AJUDA" --msgbox "Informe os números dos agendanentos separados por\nvírgula para remover os agendamentos desejados \
ou por um '-' para remover uma série de agendamentos, com o menor número e o maior número desejados." 0 0
			elif [ "$var" = "1" ]; then
				remover_secundario
			else
				if [ $(echo $res | grep -i '[a-z]') ] ; then
					erro_principal "Dado inválido! Informe apenas números. Ex.: 1,3 ou 1-3" ; remover_secundario
				fi
				if [ $(echo $res | grep ',') ]; then
					res=$(echo -e "$res" | tr ',' ' ')
				elif [ $(echo $res | grep '-') ]; then
					na=$(echo -e "$res" | cut -d "-" -f1) ; nb=$(echo -e "$res" | cut -d "-" -f2)
					if [ $nb -lt $na ]; then
						nc=$na ; na=$nb ; nb=$nc
					fi
					res=$(seq $na $nb | tr '\n' ' ')
				fi
				res1="" ; res2=""
				for i in $res
				do 
					res1="$(echo -e  "$i")" ; res2="$(echo -e "$res1\n$res2")" 
				done
				res=$(echo "$res2" | sort -n | tr '\n' ' ')
				res=$(echo "$res" | tr -s ' ')
				echo "$res" > $pasta_conficuracao/removidos$d.conf
				tot="$(wc -l $pasta_conficuracao/agendamentos$d.conf | cut -d " " -f1)"
				for i in $res
				do
					q=1
					while true
					do 
						k=$(sed -n "$q,$q p" $pasta_conficuracao/agendamentos$d.conf | cut -d '-' -f1)
						if [ "$k" = "$i " ]; then
							sed "$q d" $pasta_conficuracao/agendamentos$d.conf > \
							$pasta_conficuracao/temp.conf
							mv $pasta_conficuracao/temp.conf $pasta_conficuracao/agendamentos$d.conf
							sed '/^$/d' $pasta_conficuracao/agendamentos$d.conf > \
							$pasta_conficuracao/temp.conf && mv $pasta_conficuracao/temp.conf \
							$pasta_conficuracao/agendamentos$d.conf
							sed "$q d" $pasta_conficuracao/descricao$d.conf > $pasta_conficuracao/temp.conf
							mv $pasta_conficuracao/temp.conf $pasta_conficuracao/descricao$d.conf
							sed '/^$/d' $pasta_conficuracao/descricao$d.conf > \
							$pasta_conficuracao/temp.conf && mv $pasta_conficuracao/temp.conf \
							$pasta_conficuracao/descricao$d.conf
						fi
						if [ $q -ge $tot ]; then
							break
						fi
						q=$[q + 1]
					done
				done
				break
			fi
		else
			sem_compromisso "$nome_termo"
			break
		fi
	done
	remover_secundario
}

remover_principal(){
	opcao1=$(dialog --title "MENU - REMOÇÃO DE AGENDAMENTOS" --menu \
"Qual tipo de agendamento que deseja remover?" 12 48 5 \
"1" "Remover agendamentos semanais" \
"2" "Remover agendamentos mensais" \
"3" "Remover agendamentos anuais" \
"4" "Menu principal" \
"5" "Sair" \
--stdout)
	clear
	case $opcao1 in
		1) remover_lista "SEMANAIS" "d" ;;
		2) remover_lista "MENSAIS" "m" ;;
		3) remover_lista "ANUAIS" "a" ;;
		4) menu_principal ;;
		5) sair ;;
		*) cancelar ;;
	esac
}

listar_lista(){
	nome_termo=$1 ; d=$2
	con=$(wc -l $pasta_conficuracao/agendamentos$d.conf | cut -d " " -f1)
	if [ "$con" != "0" ]; then 
		con1=${#nome_termo}
		dialog --nocancel  --title "AGENDAMENTOS $nome_termo" --msgbox "$(
i=1
tot=$(wc -l $pasta_conficuracao/agendamentos$d.conf | cut -d " " -f1)
while true
do 
	a=$(sed -n "$i,$i p" $pasta_conficuracao/agendamentos$d.conf | cut -d ":" -f1) 
	b=$(sed -n "$i,$i p" $pasta_conficuracao/descricao$d.conf)
	c=$(sed -n "$i,$i p" $pasta_conficuracao/agendamentos$d.conf | cut -d '|' -f2)
	echo -e "$a: $b $c\n"
	if [ $i -eq  $tot ]; then
		break
	fi
	i=$[i+1]
done)"  0 0
	else
		sem_compromisso "$nome_termo"
	fi
	listar_secundario
}

listar_principal(){
	opcao1=$(dialog --title "MENU - LISTA DE AGENDAMENTOS" --menu \
"Qual tipo de agendamento que deseja ver?" 12 48 5 \
"1" "Listar agendamentos semanais" \
"2" "Listar agendamentos mensais" \
"3" "Listar agendamentos anuais" \
"4" "Menu principal" \
"5" "Sair" \
--stdout)
	case $opcao1 in
		1) listar_lista "SEMANAIS" "d" ;;
		2) listar_lista "MENSAIS" "m" ;;
		3) listar_lista "ANUAIS" "a" ;;
		4) menu_principal ;;
		5) sair ;;
		*) cancel ;;
	esac
}

sair(){
	display_principal "SAINDO" "Saindo do agendador." ; exit 0
}

cancelar(){
	display_principal "SAINDO" "Cancelado pelo usuário." ; exit 0
}

menu_principal(){
	texto="SETAS PARA ESCOLHER E ENTER PARA CONFIRMAR"
	cont="$[${#texto} + 4]"
	opcao=$(dialog --title "MENU - PRINCIPAL" --menu "$texto" 11 $cont 4 \
"1" "AGENDAR" \
"2" "REMOVER AGENDAMENTOS" \
"3" "LISTAR AGENDAMENTOS" \
"4" "SAIR" \
--stdout)
	clear
	case $opcao in 
		1) agendamento_principal ;;
		2) remover_principal ;;
		3) listar_principal ;;
		4) sair ;;
		*) cancelar ;;
	esac
}

menu_principal
