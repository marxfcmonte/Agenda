#!/bin/bash


if [ "$USER" != "root" ]; then
	echo "Use comando 'sudo'  ou comando 'su' antes de inicializar o programa."
	exit 1
fi

if ! [ -e "/usr/bin/dialog" ]; then
	echo -e "Dialog não instalado e será instalado...\n"
	apt install -y dialog
fi

if ! [ -e "/usr/bin/roxterm" ]; then
	echo -e "Dialog não instalado e será instalado...\n"
	apt install -y roxterm
fi

# O Terminal Roxterm

term="roxterm" 

texto="Para a Distribuição Debian 12 e derivados (antiX 23)"
cont="$[${#texto} + 4]"
dialog --title "Desenvolvedor" --infobox "Desenvolvido por Marx F. C. Monte\n
Instalador do Agendador de tarefas v 1.8.1 (2025)\n
Para a Distribuição Debian 12 e derivados (antiX 23)" 5 $cont
sleep 3
clear

menu(){
	
	texto="SETAS PARA ESCOLHER E ENTER PARA CONFIRMAR"
	cont="$[${#texto} + 4]"
	opcao=$(dialog --title "MENU DE INSTALAÇÃO" --menu "$texto" 10 $cont 3 \
"1" "PARA INSTALAR" \
"2" "PARA REMOVER" \
"3" "PARA SAIR" \
--stdout)
	clear
	pastab="/usr/share/pixmaps/Agendador"
	pastaj="/usr/share/Agendador"
	pastaa="/home/$SUDO_USER/.Agendador"
	case $opcao in
		1)
		texto="Instalação sendo iniciada..."
		cont="$[${#texto} + 4]"
		dialog --infobox "$texto" 3 $cont
		sleep 3
		clear
		if [ -d "$pastaj" ]; then
			texto="O diretório Agendador existe..."
			cont="$[${#texto} + 4]"
			dialog --infobox "$texto" 3 $cont
			sleep 3
			clear
		else
			texto="O diretório Agendador será criado..."
			cont="$[${#texto} + 4]"
			dialog --infobox "$texto" 3 $cont
			sleep 3
			clear
			mkdir $pastaj
		fi
		if [ -d "$pastaa" ]; then
			texto="O diretório com a configuração existe..."
			cont="$[${#texto} + 4]"
			dialog --infobox "$texto" 3 $cont
			sleep 3
			clear
		else
			texto="O diretório com a configuração será criado..."
			cont="$[${#texto} + 4]"
			dialog --infobox "$texto" 3 $cont
			sleep 3
			clear
			mkdir $pastaa
			touch $pastaa/agendaano.conf $pastaa/agendamentos.conf   
			touch $pastaa/confirmacao.conf $pastaa/agenda.conf         
			touch $pastaa/agendamentosd.conf $pastaa/finalizar.conf
			touch $pastaa/agendadia.conf $pastaa/agendamentosm.conf  
			touch $pastaa/agendamentosa.conf $pastaa/agendames.conf
			chown $SUDO_USER:$SUDO_USER $pastaa
			chown $SUDO_USER:$SUDO_USER $pastaa/*.conf
		fi
		if [ -d "$pastab" ]; then
			texto="O diretório para os icones já existe..."
			cont="$[${#texto} + 4]"
			dialog --infobox "$texto" 3 $cont
			sleep 3
			clear
		else
			texto="O diretório para os icones será criado..."
			cont="$[${#texto} + 4]"
			dialog --infobox "$texto" 3 $cont
			sleep 3
			clear
			mkdir $pastab
			cat <<EOF > $pastaj/agendador_icones
https://raw.githubusercontent.com/marxfcmonte/Agenda/\
refs/heads/main/Icones/agenda.png

EOF
			wget -i $pastaj/agendador_icones -P /tmp/
			mv /tmp/agenda.png $pastab
		fi
		cat <<EOF > $pastaj/agendador.sh
#!$SHELL

cadastro_principal(){ 
	hora="00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23"
	minuto="00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 \
24 25 26 27 26 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 \
48 49 50 51 52 53 54 55 56 57 58 59"
	descricao=\$(dialog --title "Descrição" --inputbox "Nome do agendamento: " 0 0 \
--stdout) 
	clear
	if [ "\$descricao" ]; then 
		while true
		do	
			tempoh=\$(dialog --title "Tempo da hora" --inputbox "Informe a hora [00 a 23]: " 8 29 \
--stdout) 
			clear
			if [ "\$tempoh" ]; then
				for j in \$hora
				do
					echo "\$j"
					if [ "\$tempoh" = "\$j" ]; then
						teste=0
						break
					else
						teste=1
					fi
				done
				if [ "\$teste" -eq 1 ]; then
					clear
					dialog --title "ERRO" --infobox "HORA INVÁLIDA!" 3 18
					sleep 1
					clear
				else
					break
				fi
			else
				cancelar
			fi
		done
		while true
		do	
			tempom=\$(dialog --title "Tempo do minuto" --inputbox "Informe a minuto [00 a 59]: " 8 32 \
--stdout)
			clear
			if [ "\$tempom" ]; then
				for j in \$minuto
				do
					if [ "\$tempom" = "\$j" ]; then
						teste=0
						break
					else
						teste=1
					fi
				done
				if [ "\$teste" -eq 1 ]; then
					clear
					dialog --title "ERRO" --infobox "MINUTO INVÁLIDO!" 3 20
					sleep 1
					clear
				else
					break
				fi 
			else
				cancelar
			fi
		done
	else
		cancelar
	fi
}

semana_principal(){
	dia=\$(date +%u)
	case \$dia in
		1) estado=("ON" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		2) estado=("OFF" "ON" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		3) estado=("OFF" "OFF" "ON" "OFF" "OFF" "OFF" "OFF") ;;
		4) estado=("OFF" "OFF" "OFF" "ON" "OFF" "OFF" "OFF") ;;
		5) estado=("OFF" "OFF" "OFF" "OFF" "ON" "OFF" "OFF") ;;
		6) estado=("OFF" "OFF" "OFF" "OFF" "OFF" "ON" "OFF") ;;
		7) estado=("OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "ON") ;;
	esac
	opcao2=\$(dialog --no-cancel --title "MENU - DIAS DA SEMANA" --checklist \
"Qual dos dias da semana serão habilitados?" 14 47 7 \
"1" "Segunda-feira" \${estado[0]} \
"2" "Terça-feira" \${estado[1]} \
"3" "Quarta-feira" \${estado[2]} \
"4" "Quinta-feira" \${estado[3]} \
"5" "Sexta-feira" \${estado[4]} \
"6" "Sábado" \${estado[5]} \
"7" "Domingo" \${estado[6]} \
--stdout)
}

mes_principal(){
	mes=\$(date +%m)
	case \$mes in
		"01") estado1=("ON" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"02") estado1=("OFF" "ON" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"03") estado1=("OFF" "OFF" "ON" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"04") estado1=("OFF" "OFF" "OFF" "ON" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"05") estado1=("OFF" "OFF" "OFF" "OFF" "ON" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"06") estado1=("OFF" "OFF" "OFF" "OFF" "OFF" "ON" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"07") estado1=("OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "ON" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"08") estado1=("OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "ON" "OFF" "OFF" "OFF" "OFF") ;;
		"09") estado1=("OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "ON" "OFF" "OFF" "OFF") ;;
		"10") estado1=("OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "ON" "OFF" "OFF") ;;
		"11") estado1=("OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "ON" "OFF") ;;
		"12") estado1=("OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "ON") ;;
	esac
	opcao3=\$(dialog --no-cancel --title "MENU - MESES D0 ANO" --checklist \
"Qual dos meses serão habilitados?" 19 38 12 \
"01" "Janeiro" \${estado1[0]} \
"02" "Fevereiro" \${estado1[1]} \
"03" "Março" \${estado1[2]} \
"04" "Abril" \${estado1[3]} \
"05" "Maio" \${estado1[4]} \
"06" "Junho" \${estado1[5]} \
"07" "Julho" \${estado1[6]} \
"08" "Agosto" \${estado1[7]} \
"09" "Setembro" \${estado1[8]} \
"10" "Outubro" \${estado1[9]} \
"11" "Novembro" \${estado1[10]} \
"12" "Dezembro" \${estado1[11]} \
--stdout)
}

ano_principal(){
	ano=\$(date +%Y)
	case \$ano in
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
	opcao4=\$(dialog --no-cancel --title "MENU - ANOS DE 2025 A 2036" --checklist \
"Qual dos anos serão habilitados?" 19 37 12 \
"2025" "Ano 2025" \${estado2[0]} \
"2026" "Ano 2026" \${estado2[1]} \
"2027" "Ano 2027" \${estado2[2]} \
"2028" "Ano 2028" \${estado2[3]} \
"2029" "Ano 2029" \${estado2[4]} \
"2030" "Ano 2030" \${estado2[5]} \
"2031" "Ano 2031" \${estado2[6]} \
"2032" "Ano 2032" \${estado2[7]} \
"2033" "Ano 2033" \${estado2[8]} \
"2034" "Ano 2034" \${estado2[9]} \
"2035" "Ano 2035" \${estado2[10]} \
"2036" "Ano 2036" \${estado2[11]} \
--stdout)
}

agendamento_principal(){
	num1=\$[\$(cat $pastaa/agendamentosd.conf | tail -n 1 | cut -d " " -f1) + 1 ]
	if ! [ \$num1 ]; then
		num1=0
	fi
	num2=\$[\$(cat $pastaa/agendamentosm.conf | tail -n 1 | cut -d " " -f1) + 1 ]
	if ! [ \$num2 ]; then
		num2=0
	fi
	num3=\$[\$(cat $pastaa/agendamentosa.conf | tail -n 1 | cut -d " " -f1) + 1 ]
	if ! [ \$num3 ]; then
		num3=0
	fi
	opcao1=\$(dialog --title "MENU - TIPOS DE AGENDAMEBTOS" --menu \
"Qual tipo de agendamento que deseja?" 12 40 5 \
"1" "Agendamentos semanais" \
"2" "Agendamentos mensais" \
"3" "Agendamentos anuais" \
"4" "Menu principal" \
"5" "Sair" \
--stdout)
	case \$opcao1 in
		1) 
		cadastro_principal
		semana_principal
		teste=0
		k=""
		for i in \$opcao2
		do	
			if [ teste -eq 0 ]; then
				k=\$i
				semana="\$k"
				teste=1
			else
				semana="\$k\$i "
				k="\$k\$i "
			fi
		done
		semana=\${semana:0:\$[\${#semana} - 1]}
		sed '/^\$/d' $pastaa/agendamentosd.conf > $pastaa/temp.conf && mv $pastaa/temp.conf $pastaa/agendamentosd.conf
		echo "\$num1 - Descrição: \$descricao Dias da Semana: \$semana Horário: \$tempoh:\$tempom" >> $pastaa/agendamentosd.conf
		clear
		tamanho="\$(cat $pastaa/agendamentosd.conf | tail -n 1)"
		tamanho=\${#tamanho}
		tamanho=\$[tamanho / 5]
		dialog --nocancel --title "AGENDAMENTO" --pause "\$(cat $pastaa/agendamentosd.conf | tail -n 1)" \$tamanho 70 20
		clear
		opcao1=\$(dialog --title "MENU" --menu \
"Qual opção vai escolher?" 10 30 3 \
"1" "Menu de agendamentos" \
"2" "Menu principal" \
"3" "Sair" \
--stdout)
		clear
		num=\$(cat $pastaa/finalizar.conf)
		case \$opcao1 in
			1)
			agendamento_principal
			;;
			2)
			menu_principal
			;;
			3)
			sair
			;;
			*)
			cancelar
			;;
		esac
		;;
		2)
		cadastro_principal
		semana_principal
		mes_principal
		teste=0
		k=""
		for i in \$opcao2
		do	
			if [ teste -eq 0 ]; then
				k=\$i
				semana="\$k"
				teste=1
			else
				semana="\$k\$i "
				k="\$k\$i "
			fi
		done
		teste=0
		k=""
		for i in \$opcao3
		do	
			if [ teste -eq 0 ]; then
				k=\$i
				meses="\$k"
				teste=1
			else
				meses="\$k\$i "
				k="\$k\$i "
			fi
		done
		semana=\${semana:0:\$[\${#semana} - 1]}
		meses=\${meses:0:\$[\${#meses} - 1]}
		sed '/^\$/d' $pastaa/agendamentosm.conf > $pastaa/temp.conf && mv $pastaa/temp.conf $pastaa/agendamentosm.conf
		echo "\$num2 - Descrição: \$descricao Meses do ano: \$meses Dias da Semana: \$semana Horário: \$tempoh:\$tempom" >> $pastaa/agendamentosm.conf
		clear
		tamanho="\$(cat $pastaa/agendamentosm.conf | tail -n 1)"
		tamanho=\${#tamanho}
		tamanho=\$[tamanho / 7]
		dialog --nocancel --title "AGENDAMENTO" --pause "\$(cat $pastaa/agendamentosm.conf | tail -n 1) " \$tamanho 70 20
		clear
		opcao1=\$(dialog --title "MENU" --menu \
"Qual opção vai escolher?" 10 28 3 \
"1" "Menu de agendamentos" \
"2" "Menu principal" \
"3" "Sair" \
--stdout)
		clear
		num=\$(cat $pastaa/finalizar.conf)
		case \$opcao1 in
			1)
			agendamento_principal
			;;
			2)
			menu_principal
			;;
			3)
			sair
			;;
			*)
			cancelar
			;;
		esac
		;;
		3) 
		cadastro_principal
		semana_principal
		mes_principal
		ano_principal
		teste=0
		k=""
		for i in \$opcao2
		do	
			if [ teste -eq 0 ]; then
				k=\$i
				semana="\$k"
				teste=1
			else
				semana="\$k\$i "
				k="\$k\$i "
			fi
		done
		teste=0
		k=""
		for i in \$opcao3
		do	
			if [ teste -eq 0 ]; then
				k=\$i
				meses="\$k"
				teste=1
			else
				meses="\$k\$i "
				k="\$k\$i "
			fi
		done
		teste=0
		k=""
		for i in \$opcao4
		do	
			if [ teste -eq 0 ]; then
				k=\$i
				anos="\$k"
				teste=1
			else
				anos="\$k\$i "
				k="\$k\$i "
			fi
		done
		semana=\${semana:0:\$[\${#semana} - 1]}
		meses=\${meses:0:\$[\${#meses} - 1]}
		anos=\${anos:0:\$[\${#anos} - 1]}
		sed '/^\$/d' $pastaa/agendamentosa.conf > $pastaa/temp.conf && mv $pastaa/temp.conf $pastaa/agendamentosa.conf
		echo "\$num3 - Descrição: \$descricao Anos: \$anos Meses do ano: \$meses Dias da Semana: \
\$semana Horário: \$tempoh:\$tempom" >> $pastaa/agendamentosa.conf
		clear
		dialog --nocancel --no-collapse --title "LISTA DE AGENDAMENTOS ANUAIS" \
		--textbox "$pastaa/agendamentosa.conf | tail -n 1" 0 0 
		tamanho="\$(cat $pastaa/agendamentosa.conf | tail -n 1)"
		tamanho=\${#tamanho}
		tamanho=\$[tamanho / 7]
		dialog --nocancel --title "AGENDAMENTO" --pause "\$(cat $pastaa/agendamentosa.conf | tail -n 1) " \$tamanho 70 20
		clear
		opcao1=\$(dialog --title "MENU" --menu \
"Qual opção vai escolher?" 10 28 3 \
"1" "Menu de agendamentos" \
"2" "Menu principal" \
"3" "Sair" \
--stdout)
		clear
		num=\$(cat $pastaa/finalizar.conf)
		case \$opcao1 in
			1)
			agendamento_principal
			;;
			2)
			menu_principal
			;;
			3)
			sair
			;;
			*)
			cancelar
			;;
		esac
		;;
		4)
		menu_principal
		;;
		5) 
		sair
		;;
		*)
		cancelar
		;;
	esac
}

remover_principal(){
	num=\$(cat $pastaa/agendamentosd.conf | tail -n 1 | cut -d " " -f1)
	if ! [ \$num ]; then
		num=0
	fi
	num1=\$(cat $pastaa/agendamentosm.conf | tail -n 1 | cut -d " " -f1)
	if ! [ \$num1 ]; then
		num1=0
	fi
	num2=\$(cat $pastaa/agendamentosa.conf | tail -n 1 | cut -d " " -f1)
	if ! [ \$num2 ]; then
		num2=0
	fi
	opcao1=\$(dialog --title "MENU - REMOÇÃO DE AGENDAMENTOS" --menu \
"Qual tipo de agendamento que deseja remover?" 12 48 5 \
"1" "Remover agendamentos semanais" \
"2" "Remover agendamentos mensais" \
"3" "Remover agendamentos anuais" \
"4" "Menu principal" \
"5" "Sair" \
--stdout)
	clear
	case \$opcao1 in
		1)
		if [ "\$num" != "0" ]; then 
			res=\$(dialog --title "AGENDAMENTOS SEMANAIS" --keep-window --begin 0 0 \
--msgbox "\$(cat $pastaa/agendamentosd.conf)" 0 0 --and-widget --keep-window --begin 13 48 \
--inputbox "Informe o número do\nagendamento para remover?\n\
[Use um espaço entre\nos números informados.]" 0 0 --stdout) 
			res=\$(echo "\$res" | grep -o '[0-9]' | sort -n | tr '\n' ' ')
			if [ "\$res" ]; then 
				for i in \$res
				do
					awk -F "\$i - " '{print \$1}' $pastaa/agendamentosd.conf > $pastaa/temp.conf
					mv $pastaa/temp.conf $pastaa/agendamentosd.conf
				done
			fi
			sed '/^\$/d' $pastaa/agendamentosd.conf> $pastaa/temp.conf && mv $pastaa/temp.conf $pastaa/agendamentosd.conf
			k=1
			num=\$(cat $pastaa/agendamentosd.conf | cut -d " " -f1)
			if ! [ \$num ]; then
				num=0
			fi
			for i in \$num
			do
				sed "s/\$i -/\$k -/g" $pastaa/agendamentosd.conf > $pastaa/temp.conf
				mv $pastaa/temp.conf $pastaa/agendamentosd.conf
				k=\$[k + 1]
			done
		else
			dialog --nocancel --title "SEM AGENDAMENTOS SEMANAIS" --msgbox "Sem Compromissos agendados." 5 31
		fi
		clear
		opcao1=\$(dialog --title "MENU" --menu \
"Qual opção vai escolher?" 10 41 3 \
"1" "Menu de remoção de agendamentos" \
"2" "Menu principal" \
"3" "Sair" \
--stdout)
		clear
		case \$opcao1 in
			1)
			remover_principal
			;;
			2)
			menu_principal
			;;
			3)
			sair
			;;
			*)
			cancelar
			;;
		esac
		;;
		2)
		if [ "\$num1" != "0" ]; then 
			res=\$(dialog --title "AGENDAMENTOS MENSAIS" --keep-window --begin 0 0 \
--msgbox "\$(cat $pastaa/agendamentosm.conf)" 0 0 --and-widget --keep-window --begin 13 48 \
--inputbox "Informe o número do\nagendamento para remover?\n\
[Use um espaço entre\nos números informados.]" 0 0 --stdout) 
			res=\$(echo "\$res" | grep -o '[0-9]' | sort -n | tr '\n' ' ')
			if [ "\$res" ]; then 
				for i in \$res
				do
					awk -F "\$i - " '{print \$1}' $pastaa/agendamentosm.conf > $pastaa/temp.conf
					mv $pastaa/temp.conf $pastaa/agendamentosm.conf
				done
			fi
			sed '/^\$/d' $pastaa/agendamentosm.conf> $pastaa/temp.conf && mv $pastaa/temp.conf $pastaa/agendamentosm.conf
			k=1
			num1=\$(cat $pastaa/agendamentosm.conf | cut -d " " -f1)
			if ! [ \$num1 ]; then
				num1=0
			fi
			for i in \$num1
			do
				sed "s/\$i -/\$k -/g" $pastaa/agendamentosm.conf > $pastaa/temp.conf
				mv $pastaa/temp.conf $pastaa/agendamentosm.conf
				k=\$[k + 1]
			done
		else
			dialog --nocancel --title "SEM AGENDAMENTOS MENSAIS" --msgbox "Sem Compromissos agendados." 5 31
		fi
		clear
		opcao1=\$(dialog --title "MENU" --menu \
"Qual opção vai escolher?" 10 41 3 \
"1" "Menu de remoção de agendamentos" \
"2" "Menu principal" \
"3" "Sair" \
--stdout)
		clear
		case \$opcao1 in
			1)
			remover_principal
			;;
			2)
			menu_principal
			;;
			3)
			sair
			;;
			*)
			cancelar
			;;
		esac
		;;
		3)
		if [ "\$num2" != "0" ]; then 
			res=\$(dialog --title "AGENDAMENTOS ANUAIS" --keep-window --begin 0 0 \
--msgbox "\$(cat $pastaa/agendamentosa.conf)" 0 0 --and-widget --keep-window --begin 13 48 \
--inputbox "Informe o número do\nagendamento para remover?\n\
[Use um espaço entre\nos números informados.]" 0 0 --stdout) 
			res=\$(echo "\$res" | grep -o '[0-9]' | sort -n | tr '\n' ' ')
			if [ "\$res" ]; then 
				for i in \$res
				do
					awk -F "\$i - " '{print \$1}' $pastaa/agendamentosa.conf > $pastaa/temp.conf
					mv $pastaa/temp.conf $pastaa/agendamentosa.conf
				done
			fi
			sed '/^\$/d' $pastaa/agendamentosa.conf> $pastaa/temp.conf && mv $pastaa/temp.conf $pastaa/agendamentosa.conf
			num2=\$(cat $pastaa/agendamentosa.conf | cut -d " " -f1)
			if ! [ \$num2 ]; then
				num2=0
			fi
			k=1
			for i in \$num2
			do
				sed "s/\$i -/\$k -/g" $pastaa/agendamentosa.conf > $pastaa/temp.conf
				mv $pastaa/temp.conf $pastaa/agendamentosa.conf
				k=\$[ k + 1 ]
			done
		else
			dialog --nocancel --title "SEM AGENDAMENTOS ANUAIS" --msgbox "Sem Compromissos agendados." 5 31
		fi
		clear
		opcao1=\$(dialog --title "MENU" --menu \
"Qual opção vai escolher?" 10 41 3 \
"1" "Menu de remoção de agendamentos" \
"2" "Menu principal" \
"3" "Sair" \
--stdout)
		clear
		case \$opcao1 in
			1)
			remover_principal
			;;
			2)
			menu_principal
			;;
			3)
			sair
		esac
		;;
		4)
		menu_principal
		;;
		5)
		sair
		;;
		*)
		cancelar
		;;
	esac
}

listar_principal(){
	num=\$(cat $pastaa/agendamentosd.conf | tail -n 1 | cut -d " " -f1)
	if ! [ "\$num" ]; then
		num=0
	fi
	num1=\$(cat $pastaa/agendamentosm.conf | tail -n 1 | cut -d " " -f1)
	if ! [ "\$num1" ]; then
		num1=0
	fi
	num2=\$(cat $pastaa/agendamentosa.conf | tail -n 1 | cut -d " " -f1)
	if ! [ "\$num2" ]; then
		num2=0
	fi
	opcao1=\$(dialog --title "MENU - LISTA DE AGENDAMENTOS" --menu \
"Qual tipo de agendamento que deseja ver?" 12 48 5 \
"1" "Listar agendamentos semanais" \
"2" "Listar agendamentos mensais" \
"3" "Listar agendamentos anuais" \
"4" "Menu principal" \
"5" "Sair" \
--stdout)
	case \$opcao1 in
		1)
		if [ "\$num" != "0" ]; then 
			dialog --title "LISTA DE AGENDAMENTOS SAMANAIS" \
--msgbox "\$(cat $pastaa/agendamentosd.conf)" 0 0 
		else
			dialog --nocancel --title "SEM AGENDAMENTOS SAMANAIS" --msgbox "Sem Compromissos agendados." 5 31
		fi
		clear
		opcao1=\$(dialog --title "MENU" --menu \
"Qual opção vai escolher?" 10 37 3 \
"1" "Menu de listar agendamentos" \
"2" "Menu principal" \
"3" "Sair" \
--stdout)
		clear
		case \$opcao1 in
			1)
			listar_principal
			;;
			2)
			menu_principal
			;;
			3)
			sair
			;;
			*)
			cancelar
			;;
		esac
		;;
		2)
		if [ "\$num1" != "0" ]; then 
			dialog --nocancel --no-collapse --title "LISTA DE AGENDAMENTOS MENSAIS" \
--msgbox "\$(cat $pastaa/agendamentosm.conf)" 0 0 
		else
			dialog --nocancel --title "SEM AGENDAMENTOS MENSAIS" --msgbox "Sem Compromissos agendados." 5 31
		fi
		clear
		opcao1=\$(dialog --title "MENU" --menu \
"Qual opção vai escolher?" 10 37 3 \
"1" "Menu de listar agendamentos" \
"2" "Menu principal" \
"3" "Sair" \
--stdout)
		clear
		case \$opcao1 in
			1)
			listar_principal
			;;
			2)
			menu_principal
			;;
			3)
			sair
			;;
			*)
			cancelar
			;;
		esac
		;;
		3)
		if [ "\$num2" != "0" ]; then 
			dialog --nocancel --no-collapse --title "LISTA DE AGENDAMENTOS ANUAIS" \
--msgbox "\$(cat $pastaa/agendamentosa.conf)" 0 0 
		else
			dialog --nocancel --title "SEM AGENDAMENTOS ANUAIS" --msgbox "Sem Compromissos agendados." 5 31
		fi
		clear
		opcao1=\$(dialog --title "MENU" --menu \
"Qual opção vai escolher?" 10 37 3 \
"1" "Menu de listar agendamentos" \
"2" "Menu principal" \
"3" "Sair" \
--stdout)
		clear
		case \$opcao1 in
			1)
			listar_principal
			;;
			2)
			menu_principal
			;;
			3)
			sair
			;;
			*)
			cancelar
			;;
		esac
		;;
		4)
		menu_principal
		;;
		5)
		sair
		;;
		*)
		cancelar
		;;
	esac
	}

sair(){
	clear
	dialog --title "SAINDO" --infobox "Saindo do agendador." 3 24
	sleep 1
	clear
	exit 0
}

cancelar(){
	clear
	dialog --title "SAINDO" --infobox "Cancelado pelo usuário." 3 27
	sleep 1
	clear
	exit 0
}

menu_principal(){
	texto="SETAS PARA ESCOLHER E ENTER PARA CONFIRMAR"
	cont="\$[\${#texto} + 4]"
	opcao=\$(dialog --title "MENU - PRINCIPAL" --menu "\$texto" 11 \$cont 4 \
"1" "AGENDAR" \
"2" "REMOVER AGENDAMENTOS" \
"3" "LISTAR AGENDAMENTOS" \
"4" "SAIR" \
--stdout)
	clear
	case \$opcao in 
		1)
		agendamento_principal
		;;
		2)
		remover_principal
		;;
		3)
		listar_principal
		;;
		4)
		sair
		;;
		*)
		cancelar
		;;
	esac
}

if ! [ -e $pastaa/agendamentosd.conf ]; then
	touch $pastaa/agendamentosd.conf
fi
if ! [ -e $pastaa/agendamentosm.conf ]; then
	touch $pastaa/agendamentosm.conf
fi
if ! [ -e $pastaa/agendamentosa.conf ]; then
	touch $pastaa/agendamentosa.conf
fi

menu_principal

exit 0

EOF
		cat <<EOF > $pastaj/temporalizador.sh
#!$SHELL

n1=1
n2=1
n3=1
echo "0" > $pastaa/finalizar.conf

while true
do
	
	diaconfiguracao=\$(cat $pastaa/agendamentosd.conf)
	mesconfiguracao=\$(cat $pastaa/agendamentosm.conf)
	anoconfiguracao=\$(cat $pastaa/agendamentosa.conf)
	test="\${#diaconfiguracao}"
	test1="\${#mesconfiguracao}"
	test2="\${#anoconfiguracao}"
	if [ "\$test" != "0" ]; then
		cont=\$(echo -e "\$diaconfiguracao" | tail -n 1 | cut -d "-" -f1)
		cont=\$(echo "\${cont:0:\$[\${#cont} - 1]}")
	else
		cont=0
	fi
	if [ "\$test1" != "0" ]; then
		cont1=\$(echo -e "\$mesconfiguracao" | tail -n 1 | cut -d "-" -f1)
		cont1=\$(echo "\${cont1:0:\$[\${#cont1} - 1]}")
	else
		cont1=0
	fi
	if [ "\$test2" != "0" ]; then
		cont2=\$(echo -e "\$anoconfiguracao" | tail -n 1 | cut -d "-" -f1)
		cont2=\$(echo "\${cont2:0:\$[\${#cont2} - 1]}")
	else
		cont2=0
	fi
	ano=\$(date +%Y)
	mes=\$(date +%m)
	sem=\$(date +%w) 
	tempo="\$(date +%H):\$(date +%M)"
	if [ "\$cont" != "0" ]; then
		if [ "\$n1" = "\$cont" ]; then
			n1=1
		else
			n1=\$[n1 + 1]
		fi
		minutod=\$(echo -e "\$diaconfiguracao" | sed -n "\$n1,\$n1 p" | cut -d ":" -f5)
		horad=\$(echo -e "\$diaconfiguracao" | sed -n "\$n1,\$n1 p" | cut -d ":" -f4)
		tempod="\${horad:1:2}:\${minutod:0:2}"
		semanad=\$(echo -e "\$diaconfiguracao" | sed -n "\$n1,\$n1 p" | cut -d ":" -f3)
		semanad=\$(echo -e "\$semanad" | cut -d "H" -f1)
		semanad=\$(echo "\${semanad:1:\$[\${#semanad} - 1]}")
		for i in \$semanad
		do
			case \$sem in 
				\$i)
				if [ "\$tempo" = "\$tempod" ]; then 
					echo "\$n1" > $pastaa/agendadia.conf
					echo "1" > $pastaa/agenda.conf
					echo "0" > $pastaa/confirmacao.conf 
					sleep 1
					$term -e "bash -c $pastaj/mostrador.sh"
					while true
					do
						sleep 2
						confirmacao=\$(cat $pastaa/confirmacao.conf)
						if [ "\$confirmacao" = "1" ]; then
							sleep 60
							break
						fi
						sleep 1
					done
					sleep 2
				fi
				;;
			esac
		done
	fi
	if [ "\$cont1" != "0" ]; then
		if [ "\$n2" = "\$cont1" ]; then
			n2=1
		else
			n2=\$[n2 + 1]
		fi
		minutom=\$(echo -e "\$mesconfiguracao" | sed -n "\$n2,\$n2 p" | cut -d ":" -f6)
		horam=\$(echo -e "\$mesconfiguracao" | sed -n "\$n2,\$n2 p" | cut -d ":" -f5)
		tempom="\${horam:1:2}:\${minutom:0:2}"
		semanam=\$(echo -e "\$mesconfiguracao" | sed -n "\$n2,\$n2 p" | cut -d ":" -f4)
		semanam=\$(echo -e "\$semanam" | cut -d "H" -f1)
		semanam=\$(echo "\${semanam:1:\$[\${#semanam} - 1]}")
		meses=\$(echo -e "\$mesconfiguracao" | sed -n "\$n2,\$n2 p" | cut -d ":" -f3)
		meses=\$(echo -e "\$meses" | cut -d "D" -f1)
		meses=\$(echo "\${meses:0:\$[\${#meses} - 1]}")
		for i in \$meses
		do
			case \$mes in 
				\$i)
				for j in \$semanam
				do
					case \$sem in 
						\$j)
						if [ "\$tempo" = "\$tempom" ]; then 
							echo "\$n2" > $pastaa/agendames.conf
							echo "2" > $pastaa/agenda.conf
							echo "0" > $pastaa/confirmacao.conf 
							sleep 1
							$term -e "bash -c $pastaj/mostrador.sh"
							while true
							do
								sleep 2
								confirmacao=\$(cat $pastaa/confirmacao.conf)
								if [ "\$confirmacao" -eq 1 ]; then
									sleep 60
									break
								fi
								sleep 1
							done
							sleep 2
						fi
						;;
					esac
				done
				;;
			esac
		done
	fi
	if [ "\$cont2" != "0" ]; then
		if [ "\$n3" = "\$cont2" ]; then
			n3=1
		else
			n3=\$[n3 + 1]
		fi
		minutoa=\$(echo -e "\$anoconfiguracao" | sed -n "\$n3,\$n3 p" | cut -d ":" -f7)
		horaa=\$(echo -e "\$anoconfiguracao" | sed -n "\$n3,\$n3 p" | cut -d ":" -f6)
		tempoa="\${horaa:1:2}:\${minutoa:0:2}"
		semanaa=\$(echo -e "\$anoconfiguracao" | sed -n "\$n3,\$n3 p" | cut -d ":" -f5)
		semanaa=\$(echo -e "\$semanaa" | cut -d "H" -f1)
		semanaa=\$(echo "\${semanaa:1:\$[\${#semanaa} - 1]}")
		mesesa=\$(echo -e "\$anoconfiguracao" | sed -n "\$n3,\$n3 p" | cut -d ":" -f4)
		mesesa=\$(echo -e "\$mesesa" | cut -d "D" -f1)
		mesesa=\$(echo "\${mesesa:0:\$[\${#mesesa} - 1]}")
		anos=\$(echo -e "\$anoconfiguracao" | sed -n "\$n3,\$n3 p" | cut -d ":" -f3)
		anos=\$(echo -e "\$anos" | cut -d "M" -f1)
		anos=\$(echo "\${anos:0:\$[\${#anos} - 1]}")
		for i in \$anos
		do
			case \$ano in
				\$i)
				for j in \$mesesa
				do
					case \$mes in 
						\$j)
						for k in \$semanaa
						do
							case \$sem in 
								\$k)
								if [ "\$tempo" = "\$tempoa" ]; then 
									echo "\$n3" > $pastaa/agendaano.conf
									echo "3" > $pastaa/agenda.conf
									echo "0" > $pastaa/confirmacao.conf 
									sleep 1
									$term -e "bash -c $pastaj/mostrador.sh"
									while true
									do
										sleep 2
										confirmacao=\$(cat $pastaa/confirmacao.conf)
										if [ "\$confirmacao" -eq 1 ]; then
											sleep 60
											break
										fi
										sleep 1
									done
									sleep 2
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
	fi
	finalizar=\$(cat $pastaa/finalizar.conf)
	if [ "\$finalizar" = "1" ]; then
		break
	fi
	sleep 1
done


EOF
		cat <<EOF > $pastaj/mostrador.sh
#!$SHELL

anoconfiguracao=\$(cat $pastaa/agendamentosa.conf)
mesconfiguracao=\$(cat $pastaa/agendamentosm.conf)
diaconfiguracao=\$(cat $pastaa/agendamentosd.conf)
agenda=\$(cat $pastaa/agenda.conf)
case \$agenda in 
	1)
	n1=\$(cat $pastaa/agendadia.conf)
	texto=\$(echo -e "\$diaconfiguracao" | sed -n "\$n1,\$n1 p" | cut -d ":" -f2 | cut -d "D" -f1)
	texto=\$(echo "\${texto:0:\$[\${#texto} - 1]}")
	texto1="TAREFA AGENDADA - SEMANAL"
	;;
	2)
	n2=\$(cat $pastaa/agendames.conf)
	texto=\$(echo -e "\$mesconfiguracao" | sed -n "\$n2,\$n2 p" | cut -d ":" -f2 | cut -d "M" -f1)
	texto=\$(echo "\${texto:0:\$[\${#texto} - 1]}")
	texto1="TAREFA AGENDADA - MENSAL"
	;;
	3)
	n3=\$(cat $pastaa/agendaano.conf)
	texto=\$(echo -e "\$anoconfiguracao" | sed -n "\$n3,\$n3 p" | cut -d ":" -f2 | cut -d "A" -f1)
	texto=\$(echo "\${texto:0:\$[\${#texto} - 1]}")
	texto1="TAREFA AGENDADA - ANUAL"
	;;
esac
cont2="\$[\${#texto} + 4]"
cont1="\$[\${#texto1} + 4]"
if [ \$cont1 -gt \$cont2 ]; then
	cont=\$cont1
else
	cont=\$cont2
fi
dialog --colors --title "\Zb\Z1\$texto1\Zn" --msgbox "\Zb\Z1\$texto\Zn" 6 \$cont 
clear
echo "1" > $pastaa/confirmacao.conf 

exit 0

EOF
		

		cat <<EOF > /usr/share/applications/agendador.desktop
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Name=Agendador de tarefas
Name[pt_BR]=Agendador de tarefas
Exec=$term -e "bash -c $pastaj/agendador.sh"
Terminal=false
StartupNotify=true
Comment=Cria agendamentos personalizados
Comment[pt_BR]=Cria agendamentos personalizados
Categories=Utility;
Keywords=agendamento;agenda;
Keywords[pt_BR]=agendamento;agenda;
GenericName=Agendador de tarefas
GenericName[pt_BR]=Agendador de tarefas
Icon=$pastab/agenda.png

EOF
		
		cp /usr/share/applications/agendador.desktop /home/$SUDO_USER/Desktop
		texto="Os atalhos na Àrea de trabalho foram criados..."
		cont="$[${#texto} + 4]"
		dialog --infobox "$texto" 3 $cont
		sleep 3
		clear
		chmod +x $pastaj/*.sh /usr/share/applications/*.desktop
		chmod 775 /home/$SUDO_USER/Desktop/*.desktop
		chown $SUDO_USER:$SUDO_USER /home/$SUDO_USER/Desktop/*.desktop
		chown $SUDO_USER:$SUDO_USER $pastaj/temporalizador.sh
		cat /home/$SUDO_USER/.desktop-session/startup | grep -q "$pastaj/temporalizador.sh &"
		if [ "$?" = "1" ]; then
			sed '/^$/d' /home/$SUDO_USER/.desktop-session/startup > /tmp/temp.conf && mv /tmp/temp.conf /home/$SUDO_USER/.desktop-session/startup
			echo "$pastaj/temporalizador.sh &" >> /home/$SUDO_USER/.desktop-session/startup
			texto="Configuração será instalada no Startup..."
			cont="$[${#texto} + 4]"
			dialog --infobox "$texto" 3 $cont
			sleep 3
		else
			texto="A configuração encontrada e não será instalada..."
			cont="$[${#texto} + 4]"
			dialog --infobox "$texto" 3 $cont
			sleep 3
		fi
		chmod +x /home/$SUDO_USER/.desktop-session/startup
		sleep 2
		bash -c "$pastaj/temporalizador.sh &" 
		echo "0" > $pastaa/finalizar.conf
		reset
		exit 0
		;;
		2)
		if [ -d "$pastaj" ]; then
			texto="O diretório Agendador será removido..."
			cont="$[${#texto} + 4]"
			dialog --infobox "$texto" 3 $cont
			sleep 3
			clear
			service agendador stop
			update-rc.d agendador remove
			rm -rf $pastaj
			rm /etc/init.d/agendador
		else
			texto="O diretório Agendador não encontrado..."
			cont="$[${#texto} + 4]"
			dialog --infobox "$texto" 3 $cont
			sleep 3
			clear
		fi
		if [ -d "$pastab" ]; then
			texto="O diretório ../pixmaps/Agendador será removido..."
			cont="$[${#texto} + 4]"
			dialog --infobox "$texto" 3 $cont
			sleep 3
			clear
			rm -rf /usr/share/pixmaps/Agendador
		else
			texto="O diretório ../pixmaps/Agendador não encontrado..."
			cont="$[${#texto} + 4]"
			dialog --infobox "$texto" 3 $cont
			sleep 3
			clear
		fi
		if [ -e "/usr/share/applications/agendador.desktop" ]; then
			texto="O arquivo ../applications/agendador.desktop será removido..."
			cont="$[${#texto} + 4]"
			dialog --infobox "$texto" 3 $cont
			sleep 3
			clear
			rm /usr/share/applications/agendador.desktop
		else
			texto="O arquivo ../applications/agendador.desktop não encontrado..."
			cont="$[${#texto} + 4]"
			dialog --infobox "$texto" 3 $cont
			sleep 3
			clear
		fi
		if [ -e "/home/$SUDO_USER/Desktop/agendador.desktop" ]; then
			texto="O arquivo ../Desktop/agendador.desktop será removido..."
			cont="$[${#texto} + 4]"
			dialog --infobox "$texto" 3 $cont
			sleep 3
			clear
			rm /home/$SUDO_USER/Desktop/agendador.desktop
		else
			texto="O arquivo ../Desktop/agendador.desktop não encontrado..."
			cont="$[${#texto} + 4]"
			dialog --infobox "$texto" 3 $cont
			sleep 3
			clear
		fi
		cat /home/$SUDO_USER/.desktop-session/startup | grep -q "$pastaj/temporalizador.sh &"
		if [ "$?" = "1" ]; then
			texto="Configuração não encontrada.."
			cont="$[${#texto} + 4]"
			dialog --infobox "$texto" 3 $cont
		else
			texto="A configuração será deletada..."
			cont="$[${#texto} + 4]"
			dialog --infobox "$texto" 3 $cont
			sleep 3
			clear
			awk -F "$pastaj/temporalizador.sh &" '{print $1}' /home/$SUDO_USER/.desktop-session/startup > /tmp/temp.conf
			mv /tmp/temp.conf /home/$SUDO_USER/.desktop-session/startup
			sed '/^$/d' /home/$SUDO_USER/.desktop-session/startup > /tmp/temp.conf && mv /tmp/temp.conf /home/$SUDO_USER/.desktop-session/startup
			texto="Os arquivos foram removidos..."
			cont="$[${#texto} + 4]"
			dialog --infobox "$texto" 3 $cont
		fi
		chmod +x /home/$SUDO_USER/.desktop-session/startup
		sleep 3
		reset
		exit 0
		;;
		3)
		texto="Saindo do instalador..."
		cont="$[${#texto} + 4]"
		dialog --infobox "$texto" 3 $cont
		sleep 3
		reset
		exit 0
		;;
		*)
		texto="Instalação cancelada..."
		cont="$[${#texto} + 4]"
		dialog --infobox "$texto" 3 $cont
		sleep 3
		reset
		exit 0
		;;
	esac
	
}

menu

