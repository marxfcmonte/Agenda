#!/bin/bash

if [ "$USER" = "root" ]; then
	user=$SUDO_USER
else
	user=$USER
fi

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

display_principal(){
	teste=$2 
	if ! [ $teste ]; then
		cont=0
	else
		cont=$teste
	fi
	texto=$1 ; cont1=$[${#texto} + 4 - $cont]
	dialog --colors --infobox "$texto" 3 $cont1
	sleep 3
	clear	
}

menu(){
	texto="SETAS PARA ESCOLHER E ENTER PARA CONFIRMAR" ; cont="$[${#texto} + 4]"
	opcao=$(dialog --title "MENU DE INSTALAÇÃO" --menu "$texto" 10 $cont 3 \
"1" "INSTALAR" \
"2" "REMOVER" \
"3" "SAIR" \
--stdout)
	clear
	pastab=/usr/share/pixmaps/Agendador ; pastaj=/usr/share/Agendador
	pastaa=/home/$user/.Agendador
	case $opcao in
		1)
		display_principal "Instalação sendo iniciada..."
		if [ -d "$pastaj" ]; then
			display_principal "O diretório Agendador existe..."
		else
			display_principal "O diretório Agendador será criado..." ; mkdir $pastaj
		fi
		clear
		if [ -d "$pastaa" ]; then
			display_principal "O diretório com a configuração existe..."
		else
			display_principal "O diretório com a configuração será criado..."
			mkdir $pastaa ; chown $user:$user $pastaa
		fi
		clear
		if [ -d "$pastab" ]; then
			display_principal "O diretório para os icones já existe..."
		else
			display_principal "O diretório para os icones será criado..."
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

if [ "\$USER" = "root" ]; then
	user=\$SUDO_USER
else
	user=\$USER
fi

pasta_conficuracao=/home/\$user/.Agendador

erro_principal(){
	clear ; texto=\$1 ; cont=\$[\${#texto} + 4]
	dialog --colors --title "\Zr\Z1  ERRO                                                           
				\Zn" --infobox "\$texto" 3 \$cont
	sleep 1.5
	clear
}

display_principal(){
	titulo=\$1 ; texto=\$2 ; clear ; cont=\$[\${#texto} + 4]
	dialog --colors --title "\$titulo" --infobox "\$texto" 3 \$cont ; sleep 2
	clear	
}

cadastro_principal(){ 
	hora="00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23"
	minuto="00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 \
24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 \
48 49 50 51 52 53 54 55 56 57 58 59"
	descricao=\$(dialog --title "Descrição" --inputbox "Nome do agendamento: " 0 0 \
--stdout) 
	if [ "\$?" = "0" ]; then 
		while true
		do	
			tempoh=\$(dialog --title "Tempo da hora" --inputbox "Informe a hora [00 a 23]: " 8 29 \
--stdout) 
			if [ "\$?" = "0" ]; then
				for j in \$hora
				do
					if [ "\$tempoh" = "\$j" ]; then
						teste=0 ; break
					else
						teste=1
					fi
				done
				if [ \$teste -eq 1 ]; then
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
			tempom=\$(dialog --title "Tempo do minuto" --inputbox "Informe a minuto [00 a 59]: " 8 32 \
--stdout)
			if [ "\$?" = "0" ]; then
				for j in \$minuto
				do
					if [ "\$tempom" = "\$j" ]; then
						teste=0 ; break
					else
						teste=1
					fi
				done
				if [ \$teste -eq 1 ]; then
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
	dia=\$(date +%a)
	case \$dia in
		"seg") estado=("ON" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"ter") estado=("OFF" "ON" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"qua") estado=("OFF" "OFF" "ON" "OFF" "OFF" "OFF" "OFF") ;;
		"qui") estado=("OFF" "OFF" "OFF" "ON" "OFF" "OFF" "OFF") ;;
		"sex") estado=("OFF" "OFF" "OFF" "OFF" "ON" "OFF" "OFF") ;;
		"sáb") estado=("OFF" "OFF" "OFF" "OFF" "OFF" "ON" "OFF") ;;
		"dom") estado=("OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "ON") ;;
	esac
	opcao2=\$(dialog --no-cancel --title "MENU - DIAS DA SEMANA" --checklist \
"Qual dos dias da semana serão habilitados?" 14 47 7 \
"seg" "Segunda-feira" \${estado[0]} \
"ter" "Terça-feira" \${estado[1]} \
"qua" "Quarta-feira" \${estado[2]} \
"qui" "Quinta-feira" \${estado[3]} \
"sex" "Sexta-feira" \${estado[4]} \
"sáb" "Sábado" \${estado[5]} \
"dom" "Domingo" \${estado[6]} \
--stdout)
}

dia_principal(){
	dia_num=\$1 ; caso=\$2 ; dia_hoje=\$(date +%d)	
	case \$caso in 
		1) texto1="[01 a 31]" ;;
		2) texto1="[01 a 30]" ;;
		3)
		case \$dia_bi in 
			0) texto1="[01 a 29]" ;;
			1) texto1="[01 a 28]" ;;
		esac
		;;
	esac
	while true
	do
		texto="Informe o dia do(s) mês(s) \$opcao3 [\$dia_hoje]" ; cont=\$[\${#texto} + 1]
		dia_mes=\$(dialog --title "\$texto" --inputbox "Informe o dia \$texto1: " 8 \$cont \
--stdout) 
		if [ "\$?" = "0" ]; then
			if [ "\$dia_mes" ]; then
				for j in \$dia_num
				do
					if [ "\$dia_mes" = "\$j" ]; then
						teste=0 ; break
					else
						teste=1
					fi
				done
				if [ \$teste -eq 1 ]; then
					erro_principal "DIA INVÁLIDO!"
				else
					break
				fi
			else
				clear ; dia_mes=\$dia_hoje ; break
			fi
		else
			clear ; agendamento_principal ; break
		fi
	done
}

mes_principal(){
	mes=\$(date +%b)
	case \$mes in
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
	ano=\$(date +%Y) ; resto=\$[ano % 4] ; resto1=\$[ano % 100] ; resto2=\$[ano % 400]
	if [ \$resto -eq 0 ]; then
		if [ \$resto1 -ne 0 ]; then
			diab=\$dia3 ; dia_bi=0
		else
			if [ \$resto2 -eq 0 ]; then
				diab=\$dia3 ; dia_bi=0
			else
				diab=\$dia4 ; dia_bi=1
			fi
		fi
	else
		diab=\$dia4 ; dia_bi=1
	fi
	opcao3=\$(dialog --no-cancel --title "MENU - MESES D0 ANO" --checklist \
"Qual dos meses serão habilitados?" 19 38 12 \
"jan" "Janeiro" \${estado1[0]} \
"fev" "Fevereiro" \${estado1[1]} \
"mar" "Março" \${estado1[2]} \
"abr" "Abril" \${estado1[3]} \
"mai" "Maio" \${estado1[4]} \
"jun" "Junho" \${estado1[5]} \
"jul" "Julho" \${estado1[6]} \
"ago" "Agosto" \${estado1[7]} \
"set" "Setembro" \${estado1[8]} \
"out" "Outubro" \${estado1[9]} \
"nov" "Novembro" \${estado1[10]} \
"dez" "Dezembro" \${estado1[11]} \
--stdout)
	clear
	for i in \$opcao3 
	do
		case \$i in
			"fev") dia_principal "\$diab" "3" ; break ;;
			"abr"|"jun"|"set"|"nov") 
			teste=0
			for j in \$opcao3 
			do
				case \$j in
					"fev") dia_principal "\$diab" "3" ; teste=1 ; break ;;
				esac
			done
			if [ \$teste -eq 1 ]; then
				break
			fi
			dia_principal "\$dia2" "2" ; break ;;
			"jan"|"mar"|"mai"|"jul"|"ago"|"out"|"dez") 
			teste=0
			for j in \$opcao3 
			do
				case \$j in
					"fev") dia_principal "\$diab" "3" ; teste=1 ; break ;;
				esac
			done
			if [ \$teste -eq 1 ]; then
				break
			fi
			teste=0
			for j in \$opcao3 
			do
				case \$j in
					"abr"|"jun"|"set"|"nov")
					dia_principal "\$dia2" "2" ; teste=1 ; break ;;
				esac
			done
			if [ \$teste -eq 1 ]; then
				break
			fi
			dia_principal "\$dia1" "1" ; break ;;
		esac
	done
}

ano_principal(){
	ano=\$(date +%Y)
	case \$ano in
		"\$ano") estado2=("ON" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"\$[ano + 1]") estado2=("OFF" "ON" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"\$[ano + 2]") estado2=("OFF" "OFF" "ON" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"\$[ano + 3]") estado2=("OFF" "OFF" "OFF" "ON" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"\$[ano + 4]") estado2=("OFF" "OFF" "OFF" "OFF" "ON" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"\$[ano + 5]") estado2=("OFF" "OFF" "OFF" "OFF" "OFF" "ON" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"\$[ano + 6]") estado2=("OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "ON" "OFF" "OFF" "OFF" "OFF" "OFF") ;;
		"\$[ano + 7]") estado2=("OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "ON" "OFF" "OFF" "OFF" "OFF") ;;
		"\$[ano + 8]") estado2=("OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "ON" "OFF" "OFF" "OFF") ;;
		"\$[ano + 9]") estado2=("OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "ON" "OFF" "OFF") ;;
		"\$[ano + 10]") estado2=("OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "ON" "OFF") ;;
		"\$[ano + 11]") estado2=("OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "OFF" "ON") ;;
	esac
	opcao4=\$(dialog --no-cancel --title "MENU - ANOS DE \$ano A \$[ano + 11]" --checklist \
"Qual dos anos serão habilitados?" 19 37 12 \
"\$ano" "Ano \$ano" \${estado2[0]} \
"\$[ano + 1]" "Ano \$[ano + 1]" \${estado2[1]} \
"\$[ano + 2]" "Ano \$[ano + 2]" \${estado2[2]} \
"\$[ano + 3]" "Ano \$[ano + 3]" \${estado2[3]} \
"\$[ano + 4]" "Ano \$[ano + 4]" \${estado2[4]} \
"\$[ano + 5]" "Ano \$[ano + 5]" \${estado2[5]} \
"\$[ano + 6]" "Ano \$[ano + 6]" \${estado2[6]} \
"\$[ano + 7]" "Ano \$[ano + 7]" \${estado2[7]} \
"\$[ano + 8]" "Ano \$[ano + 8]" \${estado2[8]} \
"\$[ano + 9]" "Ano \$[ano + 9]" \${estado2[9]} \
"\$[ano + 10]" "Ano \$[ano + 10]" \${estado2[10]} \
"\$[ano + 11]" "Ano \$[ano + 11]" \${estado2[11]} \
--stdout)
}

sem_compromisso(){
	termo=\$1
	dialog --nocancel --title "SEM AGENDAMENTOS \$termo" --msgbox "Sem Compromissos agendados." 5 31
}

menu_secudario(){
	titulo1=\$1 ; textox=\$2 ; number=\$3
	clear
	opcaok=\$(dialog --title "MENU" --menu \
"\$titulo1" 10 \$number 3 \
"1" "\$textox" \
"2" "Menu principal" \
"3" "Sair" \
--stdout)
}

menu_terciario(){
	titulo1=\$1 ; titulo2=\$2 ; textox=\$3 ; textox1=\$4 ; textox2=\$5 
	number=\$6
	clear
	opcaok1=\$(dialog --title "MENU - \$titulo1" --menu \
"\$titulo2" 12 \$number 5 \
"1" "\$textox" \
"2" "\$textox1" \
"3" "\$textox2" \
"4" "Menu principal" \
"5" "Sair" \
--stdout)
}

agendamento_secundario(){
	menu_secudario "Qual opção vai escolher?" "Menu de agendamentos" 30
	case \$opcaok in
		1) agendamento_principal ;;
		2) menu_principal ;;
		3) sair ;;
		*) cancelar ;;
	esac
}

remover_secundario(){
	menu_secudario "Qual opção vai escolher?" "Menu de remoção de agendamentos" 41
	case \$opcaok in
		1) remover_principal ;;
		2) menu_principal ;;
		3) sair ;;
		*) cancelar ;;
	esac
}

listar_secundario(){
	menu_secudario "Qual opção vai escolher?"  "Menu de listar agendamentos" 37
	case \$opcaok in
		1) listar_principal ;;
		2) menu_principal ;;
		3) sair ;;
		*) cancelar ;;
	esac
}

arquivo_organizacao(){
	d="\$1" ; text_r="" ; text_r_1="" ; text_d="" ; text_d_1=""
	maior=\$(cat \$pasta_conficuracao/agendamentos\$d.conf | cut -d "-" -f1)
	tamanho=\$(wc -l \$pasta_conficuracao/agendamentos\$d.conf | cut -d " " -f1)
	if [ "\$tamanho" = "0" ]; then
		maior=1
	fi
	maior="\$(echo "\$maior" | tr '\n' ' ')"
	comp=1
	for i in \$maior
	do
		if [ \$i -ge \$comp ]; then
			comp=\$i
		fi
	done
	maior=\$comp
	for i in \$(seq 1 \$maior)
	do
		contad=\$(sed -n "\$i,\$i p" \$pasta_conficuracao/agendamentos\$d.conf | cut -d "-" -f1)
		if [ "\$contad" != "\$i " ]; then 
			num="\$i"
			if [ "\$num" = "1" -a "\$tamanho" != "0" ]; then
				text_r="0"
				text_r_1=\$(sed -n "1,\$maior p" \$pasta_conficuracao/agendamentos\$d.conf)
				text_d="0"
				text_d_1=\$(sed -n "1,\$maior p" \$pasta_conficuracao/descricao\$d.conf)
			elif [ "\$tamanho" = "0" ]; then
				text_r="0"
				text_d="0"
			else
				text_r=\$(sed -n "1,\$[i-1] p" \$pasta_conficuracao/agendamentos\$d.conf)
				text_r_1=\$(sed -n "\$i,\$tamanho p" \$pasta_conficuracao/agendamentos\$d.conf)
				text_d=\$(sed -n "1,\$[i-1] p" \$pasta_conficuracao/descricao\$d.conf)
				text_d_1=\$(sed -n "\$i,\$tamanho p" \$pasta_conficuracao/descricao\$d.conf)
			fi
			break
		else
			text_r=\$(sed -n "1,\$maior p" \$pasta_conficuracao/agendamentos\$d.conf)
			text_d=\$(sed -n "1,\$maior p" \$pasta_conficuracao/descricao\$d.conf)
			num="\$[maior + 1]"
		fi
	done
	retorno=("\$num" "\$text_r" "\$text_r_1" "\$text_d" "\$text_d_1")
}

imprime_agendamento(){
	num=\$1 ; d=\$2 ; titulo=\$3
	clear
	texto="\$(sed -n "\$num,\$num p" \$pasta_conficuracao/agendamentos\$d.conf | cut -d ":" -f1): \
\$(sed -n "\$num,\$num p" \$pasta_conficuracao/descricao\$d.conf) \
\$(sed -n "\$num,\$num p" \$pasta_conficuracao/agendamentos\$d.conf | cut -d "|" -f2)"
	dialog --nocancel --title "AGENDAMENTO \$titulo" --msgbox "\$texto" 0 0
}

agendamento_principal(){
	menu_terciario "TIPOS DE AGENDAMEBTOS" "Qual tipo de agendamento que deseja?" \
	"Agendamentos semanais" "Agendamentos mensais" "Agendamentos anuais" 40
	case \$opcaok1 in
		1) 
		arquivo_organizacao "d"
		num1=\${retorno[0]} ; text_res=\${retorno[1]} ; text_res_1=\${retorno[2]} 
		text_des=\${retorno[3]} ; text_des_1=\${retorno[4]}
		cadastro_principal ; semana_principal ; teste=0 ; k=""
		for i in \$opcao2
		do	
			if [ "\$teste" -eq 0 ]; then
				k="\$i " ; semana="\$k" ; teste=1
			else
				semana="\$k\$i " ; k="\$k\$i "
			fi
		done
		if [ "\${#semana}" != "0" ]; then
			semana=\${semana:0:\$[\${#semana} - 1]}
		fi
		if [ "\$text_res" != "0" ]; then
			echo "\$text_res" > \$pasta_conficuracao/agendamentosd.conf
			echo "\$num1 - Descrição: | * Dia(s) da semana: \$semana * Horário: \$tempoh:\$tempom" >> \
\$pasta_conficuracao/agendamentosd.conf
			echo "\$text_res_1" >> \$pasta_conficuracao/agendamentosd.conf
		else
			echo "\$num1 - Descrição: | * Dia(s) da semana: \$semana * Horário: \$tempoh:\$tempom" > \
\$pasta_conficuracao/agendamentosd.conf
			echo "\$text_res_1" >> \$pasta_conficuracao/agendamentosd.conf
		fi
		if [ "\$text_des" != "0" ]; then
			echo "\$text_des" > \$pasta_conficuracao/descricaod.conf
			echo "\$descricao" >> \$pasta_conficuracao/descricaod.conf
			echo "\$text_des_1" >> \$pasta_conficuracao/descricaod.conf
		else
			echo "\$descricao" > \$pasta_conficuracao/descricaod.conf
			echo "\$text_des_1" >> \$pasta_conficuracao/descricaod.conf
		fi
		sed '/^\$/d' \$pasta_conficuracao/agendamentosd.conf > \
\$pasta_conficuracao/temp.conf 
		mv \$pasta_conficuracao/temp.conf \$pasta_conficuracao/agendamentosd.conf
		sed '/^\$/d' \$pasta_conficuracao/descricaod.conf > \
\$pasta_conficuracao/temp.conf 
		mv \$pasta_conficuracao/temp.conf \$pasta_conficuracao/descricaod.conf
		chmod 664 \$pasta_conficuracao/agendamentosd.conf
		chmod 664 \$pasta_conficuracao/descricaod.conf
		imprime_agendamento "\$num1" "d" "SEMANAL" ; agendamento_secundario ;;
		2)
		arquivo_organizacao "m"
		num2=\${retorno[0]} ; text_res1=\${retorno[1]} ; text_res1_1=\${retorno[2]} 
		text_des1=\${retorno[3]} ; text_des1_1=\${retorno[4]}
		cadastro_principal ; mes_principal ; semana=\$dia_mes ; teste=0 ; k=""
		for i in \$opcao3
		do	
			if [ "\$teste" -eq 0 ]; then
				k="\$i " ; meses="\$k" ; teste=1
			else
				meses="\$k\$i " ; k="\$k\$i "
			fi
		done
		if [ "\${#meses}" != "0" ]; then
			meses=\${meses:0:\$[\${#meses} - 1]}
		fi
		if [ "\$text_res1" != "0" ]; then
			echo "\$text_res1" > \$pasta_conficuracao/agendamentosm.conf
			echo "\$num2 - Descrição: | * Mes(es) do ano: \$meses * Dia do(s) Mes(es): \$semana * Horário: \$tempoh:\$tempom" >> \
			\$pasta_conficuracao/agendamentosm.conf
			echo "\$text_res1_1" >> \$pasta_conficuracao/agendamentosm.conf
		else
			echo "\$num2 - Descrição: | * Mes(es) do ano: \$meses * Dia do(s) Mes(es): \$semana * Horário: \$tempoh:\$tempom" > \
			\$pasta_conficuracao/agendamentosm.conf
			echo "\$text_res1_1" >> \$pasta_conficuracao/agendamentosm.conf
		fi
		if [ "\$text_des1" != "0" ]; then
			echo "\$text_des1" > \$pasta_conficuracao/descricaom.conf 
			echo "\$descricao" >> \$pasta_conficuracao/descricaom.conf
			echo "\$text_des1_1" >> \$pasta_conficuracao/descricaom.conf
		else
			echo "\$descricao" > \$pasta_conficuracao/descricaom.conf
			echo "\$text_des1_1" >> \$pasta_conficuracao/descricaom.conf
		fi
		sed '/^\$/d' \$pasta_conficuracao/agendamentosm.conf > \
\$pasta_conficuracao/temp.conf 
		mv \$pasta_conficuracao/temp.conf \$pasta_conficuracao/agendamentosm.conf
		sed '/^\$/d' \$pasta_conficuracao/descricaom.conf > \
\$pasta_conficuracao/temp.conf 
		mv \$pasta_conficuracao/temp.conf \$pasta_conficuracao/descricaom.conf
		chmod 664 \$pasta_conficuracao/agendamentosm.conf
		chmod 664 \$pasta_conficuracao/descricaom.conf
		imprime_agendamento "\$num2" "m" "MENSAL" ; agendamento_secundario ;;
		3) 
		arquivo_organizacao "a"
		num3=\${retorno[0]} ; text_res2=\${retorno[1]} ; text_res2_1=\${retorno[2]} 
		text_des2=\${retorno[3]} ; text_des2_1=\${retorno[4]}
		cadastro_principal ; mes_principal ; ano_principal ; semana=\$dia_mes
		teste=0 ; k=""
		for i in \$opcao3
		do	
			if [ "\$teste" -eq 0 ]; then
				k="\$i " ; meses="\$k" ; teste=1
			else
				meses="\$k\$i " ; k="\$k\$i "
			fi
		done
		teste=0 ; k=""
		for i in \$opcao4
		do	
			if [ "\$teste" -eq 0 ]; then
				k="\$i " ; anos="\$k" ; teste=1
			else
				anos="\$k\$i " ; k="\$k\$i "
			fi
		done
		if [ "\${#meses}" != "0" ]; then
			meses=\${meses:0:\$[\${#meses} - 1]}
		fi
		if [ "\${#anos}" != "0" ]; then
			anos=\${anos:0:\$[\${#anos} - 1]}
		fi
		if [ "\$text_res2" != "0" ]; then
			echo "\$text_res2" > \$pasta_conficuracao/agendamentosa.conf
			echo "\$num3 - Descrição: | * Ano(s): \$anos * Mes(es) do ano: \$meses * Dia do(s) mes(es): \$semana * Horário: \$tempoh:\$tempom" >> \
\$pasta_conficuracao/agendamentosa.conf
			echo "\$text_res2_1" >> \$pasta_conficuracao/agendamentosa.conf
		else
			echo "\$num3 - Descrição: | * Ano(s): \$anos * Mes(es) do ano: \$meses * Dia do(s) mes(es): \$semana * Horário: \$tempoh:\$tempom" > \
\$pasta_conficuracao/agendamentosa.conf
			echo "\$text_res2_1" >> \$pasta_conficuracao/agendamentosa.conf
		fi
		if [ "\$text_des2" != "0" ]; then
			echo "\$text_des2" > \$pasta_conficuracao/descricaoa.conf
			echo "\$descricao" >> \$pasta_conficuracao/descricaoa.conf
			echo "\$text_des2_1" >> \$pasta_conficuracao/descricaoa.conf
		else
			echo "\$descricao" > \$pasta_conficuracao/descricaoa.conf
			echo "\$text_des2_1" >> \$pasta_conficuracao/descricaoa.conf
		fi
		sed '/^\$/d' \$pasta_conficuracao/agendamentosa.conf > \
\$pasta_conficuracao/temp.conf 
		mv \$pasta_conficuracao/temp.conf \$pasta_conficuracao/agendamentosa.conf
		sed '/^\$/d' \$pasta_conficuracao/descricaoa.conf > \
\$pasta_conficuracao/temp.conf 
		mv \$pasta_conficuracao/temp.conf \$pasta_conficuracao/descricaoa.conf
		chmod 664 \$pasta_conficuracao/agendamentosa.conf
		chmod 664 \$pasta_conficuracao/descricaoa.conf
		imprime_agendamento "\$num3" "a" "ANUAL" ; agendamento_secundario ;;
		4) menu_principal ;;
		5) sair ;;
		*) cancelar ;;
	esac
}

remover_lista(){
	nome_termo=\$1 ; d=\$2
	con=\$(wc -l \$pasta_conficuracao/agendamentos\$d.conf | cut -d " " -f1)
	while true
	do
		if [ "\$con" != "0" ]; then 
			res=\$(dialog --title "AGENDAMENTOS \$nome_termo" --keep-window --begin 0 0 --msgbox "\$(
i=1
tot=\$(wc -l \$pasta_conficuracao/agendamentos\$d.conf | cut -d " " -f1)
while true
do 
	a=\$(sed -n "\$i,\$i p" \$pasta_conficuracao/agendamentos\$d.conf | cut -d ":" -f1) 
	b=\$(sed -n "\$i,\$i p" \$pasta_conficuracao/descricao\$d.conf)
	c=\$(sed -n "\$i,\$i p" \$pasta_conficuracao/agendamentos\$d.conf | cut -d '|' -f2)
	echo -e "\$a: \$b \$c\n"
	if [ \$i -eq  \$tot ]; then
		break
	fi
	i=\$[i+1]
done)"  0 0 \
--and-widget --keep-window --begin 13 44 --help-button --inputbox "Informe os agendamentos para remover:" 0 0 --stdout) 
			var="\$?"
			if [ "\$var" = "2" ]; then
				dialog --title "AJUDA" --msgbox "Informe os números dos agendanentos separados por\nvírgula para remover os agendamentos desejados \
ou por um '-' para remover uma série de agendamentos, com o menor número e o maior número desejados." 0 0
			elif [ "\$var" = "1" ]; then
				remover_secundario
			else
				if [ \$(echo \$res | grep -i '[a-z]') ] ; then
					erro_principal "Dado inválido! Informe apenas números. Ex.: 1,3 ou 1-3" ; remover_secundario
				fi
				if [ \$(echo \$res | grep ',') ]; then
					res=\$(echo -e "\$res" | tr ',' ' ')
				elif [ \$(echo \$res | grep '-') ]; then
					na=\$(echo -e "\$res" | cut -d "-" -f1) ; nb=\$(echo -e "\$res" | cut -d "-" -f2)
					if [ \$nb -lt \$na ]; then
						nc=\$na ; na=\$nb ; nb=\$nc
					fi
					res=\$(seq \$na \$nb | tr '\n' ' ')
				fi
				res1="" ; res2=""
				for i in \$res
				do 
					res1="\$(echo -e  "\$i")" ; res2="\$(echo -e "\$res1\n\$res2")" 
				done
				res=\$(echo "\$res2" | sort -n | tr '\n' ' ')
				res=\$(echo "\$res" | tr -s ' ')
				echo "\$res" > \$pasta_conficuracao/removidos\$d.conf
				tot="\$(wc -l \$pasta_conficuracao/agendamentos\$d.conf | cut -d " " -f1)"
				for i in \$res
				do
					q=1
					while true
					do 
						k=\$(sed -n "\$q,\$q p" \$pasta_conficuracao/agendamentos\$d.conf | cut -d '-' -f1)
						if [ "\$k" = "\$i " ]; then
							sed "\$q d" \$pasta_conficuracao/agendamentos\$d.conf > \
\$pasta_conficuracao/temp.conf
							mv \$pasta_conficuracao/temp.conf \$pasta_conficuracao/agendamentos\$d.conf
							sed '/^\$/d' \$pasta_conficuracao/agendamentos\$d.conf > \
\$pasta_conficuracao/temp.conf 
							mv \$pasta_conficuracao/temp.conf \$pasta_conficuracao/agendamentos\$d.conf
							sed "\$q d" \$pasta_conficuracao/descricao\$d.conf > \$pasta_conficuracao/temp.conf
							mv \$pasta_conficuracao/temp.conf \$pasta_conficuracao/descricao\$d.conf
							sed '/^\$/d' \$pasta_conficuracao/descricao\$d.conf > \
\$pasta_conficuracao/temp.conf 
						mv \$pasta_conficuracao/temp.conf \$pasta_conficuracao/descricao\$d.conf
						fi
						if [ \$q -ge \$tot ]; then
							break
						fi
						q=\$[q + 1]
					done
				done
				chmod 664 \$pasta_conficuracao/agendamentos\$d.conf
				chmod 664 \$pasta_conficuracao/descricao\$d.conf
				break
			fi
		else
			sem_compromisso "\$nome_termo"
			break
		fi
	done
	remover_secundario
}

remover_principal(){
	menu_terciario "REMOÇÃO DE AGENDAMENTOS" "Qual tipo de agendamento que deseja remover?" \
	"Remover agendamentos semanais" "Remover agendamentos mensais" \
	"Remover agendamentos anuais" 48
	case \$opcaok1 in
		1) remover_lista "SEMANAIS" "d" ;;
		2) remover_lista "MENSAIS" "m" ;;
		3) remover_lista "ANUAIS" "a" ;;
		4) menu_principal ;;
		5) sair ;;
		*) cancelar ;;
	esac
}

listar_lista(){
	nome_termo=\$1 ; d=\$2
	con=\$(wc -l \$pasta_conficuracao/agendamentos\$d.conf | cut -d " " -f1)
	if [ "\$con" != "0" ]; then 
		dialog --nocancel  --title "AGENDAMENTOS \$nome_termo" --msgbox "\$(
i=1
tot=\$(wc -l \$pasta_conficuracao/agendamentos\$d.conf | cut -d " " -f1)
while true
do 
	a=\$(sed -n "\$i,\$i p" \$pasta_conficuracao/agendamentos\$d.conf | cut -d ":" -f1) 
	b=\$(sed -n "\$i,\$i p" \$pasta_conficuracao/descricao\$d.conf)
	c=\$(sed -n "\$i,\$i p" \$pasta_conficuracao/agendamentos\$d.conf | cut -d '|' -f2)
	echo -e "\$a: \$b \$c\n"
	if [ \$i -eq  \$tot ]; then
		break
	fi
	i=\$[i+1]
done)"  0 0
	else
		sem_compromisso "\$nome_termo"
	fi
	listar_secundario
}

listar_principal(){
	menu_terciario "LISTA DE AGENDAMENTOS" "Qual tipo de agendamento que deseja ver?" \
	"Listar agendamentos semanais" "Listar agendamentos mensais" \
	"Listar agendamentos anuais" 48
	case \$opcaok1 in
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
	cont="\$[\${#texto} + 4]"
	opcao=\$(dialog --title "MENU - PRINCIPAL" --menu "\$texto" 11 \$cont 4 \
"1" "AGENDAR" \
"2" "REMOVER AGENDAMENTOS" \
"3" "LISTAR AGENDAMENTOS" \
"4" "SAIR" \
--stdout)
	clear
	case \$opcao in 
		1) agendamento_principal ;;
		2) remover_principal ;;
		3) listar_principal ;;
		4) sair ;;
		*) cancelar ;;
	esac
}

menu_principal
EOF
		cat <<EOF > $pastaj/temporalizador.sh
#!$SHELL

n1=1 ; n2=1 ; n3=1

if [ "\$USER" = "root" ]; then
	user=\$SUDO_USER
else
	user=\$USER
fi

pasta_conficuracao=/home/\$user/.Agendador
pasta_aplicacoes=/usr/share/Agendador

nome="d m a"
for i in \$nome
do
	if ! [ -e "\$pasta_conficuracao/test\$i.conf" ]; then
		echo "0" > \$pasta_conficuracao/test\$i.conf
	fi
	
	if ! [ -e "\$pasta_conficuracao/agendamentos\$i.conf" ]; then
		touch \$pasta_conficuracao/agendamentos\$i.conf
	fi
	
	if ! [ -e "\$pasta_conficuracao/removidos\$i.conf" ]; then
		touch \$pasta_conficuracao/removidos\$i.conf
	fi
	if ! [ -e "\$pasta_conficuracao/descricao\$i.conf" ]; then
		touch \$pasta_conficuracao/descricao\$i.conf
	fi
done

chmod 664 \$pasta_conficuracao/*.conf
chown \$user:\$user \$pasta_conficuracao/*.conf

tempo_principal(){
	configuracao="\$1" ; ka=("\$2" "\$3" "\$4" "\$5" "\$6") ; nk="\$7"
	minutok=\$(echo -e "\$configuracao" | sed -n "\$nk,\$nk p" | cut -d ":" \${ka[0]})
	horak=\$(echo -e "\$configuracao" | sed -n "\$nk,\$nk p" | cut -d ":" \${ka[1]})
	tempok="\${horak:1:2}:\${minutok:0:2}"
	semanak=\$(echo -e "\$configuracao" | sed -n "\$nk,\$nk p" | cut -d ":" \${ka[2]})
	semanak=\$(echo -e "\$semanak" | cut -d "H" -f1)
	if [ "\${#semanak}" != "0" ]; then
		semanak=\$(echo "\${semanak:1:\$[\${#semanak} - 4]}")
	fi
	mesek=\$(echo -e "\$configuracao" | sed -n "\$nk,\$nk p" | cut -d ":" \${ka[3]})
	mesek=\$(echo -e "\$mesek" | cut -d "D" -f1)
	if [ "\${#mesek}" != "0" ]; then
		mesek=\$(echo "\${mesek:1:\$[\${#mesek} - 4]}")
	fi
	anok=\$(echo -e "\$configuracao" | sed -n "\$nk,\$nk p" | cut -d ":" \${ka[4]})
	anok=\$(echo -e "\$anok" | cut -d "M" -f1)
	if [ "\${#anok}" != "0" ]; then
		anok=\$(echo "\${anok:1:\$[\${#anok} - 4]}")
	fi
}

ativador_principal(){
	ano2=\$1 ; mes2=\$2 ; seman=\$3 ; dia1=\$4 ; n_1=\$5 ; tempo2=\$6
	teste=\$7 ; n=\$8
	ano=\$(date +%Y) ; mes=\$(date +%b) ; tempo=\$(date +%R)
	for i in \$ano2
		do
			case \$ano in
				\$i)
				for j in \$mes2
				do
					case \$mes in 
						\$j)
						for k in \$seman
						do
							case \$dia1 in 
								\$k)
								if [ "\$tempo" = "\$tempo2" ]; then 
									contador=\$(cat \$pasta_conficuracao/\$teste)
									contador=$(echo \$contador | tr '\n' ' ')
									var=1
									for i in \$contador
									do
										if [ \$i -eq \$n ]; then
											var=0
										fi
									done
									if [ \$var -eq 1 ]; then 
										echo "\$n" >> \$pasta_conficuracao/\$teste
										sed '/^\$/d' \$pasta_conficuracao/\$teste > \$pasta_conficuracao/temp.conf 
										mv \$pasta_conficuracao/temp.conf \$pasta_conficuracao/\$teste
										chown \$user:\$user \$pasta_conficuracao/\$teste
										chmod 664 \$pasta_conficuracao/\$teste
										roxterm -e "\$pasta_aplicacoes/mostrador.sh \$n_1 \$n" &
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
	diaconfiguracao="\$(cat \$pasta_conficuracao/agendamentosd.conf)"
	mesconfiguracao="\$(cat \$pasta_conficuracao/agendamentosm.conf)"
	anoconfiguracao="\$(cat \$pasta_conficuracao/agendamentosa.conf)"
	test1=\${#diaconfiguracao} ; test2=\${#mesconfiguracao}
	test3=\${#anoconfiguracao}
	if [ \$test1 -ne 0 ]; then
		cont=\$(echo -e "\$diaconfiguracao" | cut -d "-" -f1)
		test1_num=1
		for i in \$cont
		do
			if [ \$i -ge \$test1_num ]; then
				cont=\$i
			fi
		done
	else
		cont=0
	fi
	if [ \$test2 -ne 0 ]; then
		cont1=\$(echo -e "\$mesconfiguracao" | cut -d "-" -f1)
		test1_num=1
		for i in \$cont1
		do
			if [ \$i -ge \$test1_num ]; then
				cont1=\$i
			fi
		done
	else
		cont1=0
	fi
	if [ \$test3 -ne 0 ]; then
		cont2=\$(echo -e "\$anoconfiguracao" | cut -d "-" -f1)
		test1_num=1
		for i in \$cont2
		do
			if [ \$i -ge \$test1_num ]; then
				cont2=\$i
			fi
		done
	else
		cont2=0
	fi
	sem=\$(date +%a) ; dia_d=\$(date +%d) 
	for i in \$nome
	do
		removido=\$(cat \$pasta_conficuracao/removidos\$i.conf)
		linha=\$(wc -l \$pasta_conficuracao/test\$i.conf | cut -d " " -f1)
		for j in \$removido
		do
			q=2
			while true
			do 
				k=\$(sed -n "\$q,\$q p" \$pasta_conficuracao/test\$i.conf)
				if [ "\$k" = "\$j" ]; then
					sed "\$q d" \$pasta_conficuracao/test\$i.conf > \
\$pasta_conficuracao/temp.conf
					mv \$pasta_conficuracao/temp.conf \$pasta_conficuracao/test\$i.conf
					sed '/^\$/d' \$pasta_conficuracao/test\$i.conf > \
\$pasta_conficuracao/temp.conf
					mv \$pasta_conficuracao/temp.conf \
\$pasta_conficuracao/test\$i.conf
					chown \$user:\$user \$pasta_conficuracao/test\$i.conf
					chmod 664 \$pasta_conficuracao/test\$i.conf
				fi
				if [ \$q -ge \$linha ]; then
					break
				fi
				q=\$[q + 1]
			done
		done
		echo "0" > \$pasta_conficuracao/removidos\$i.conf
	done
	
		if [ "\$tempo" = "00:00" ]; then
			for i in \$nome
			do
				echo "0" > \$pasta_conficuracao/test\$i.conf
			done
		fi
	
	if [ \$cont -ne 0 ]; then
		if [ \$n1 -ge \$cont ]; then
			n1=1
		else
			n1=\$[ n1 + 1 ]
		fi
		tempo_principal "\$diaconfiguracao" "-f5" "-f4" "-f3" "-f2" "-f1" "\$n1"
		ativador_principal "\$ano" "\$mes" "\$semanak" "\$sem" "1" "\$tempok" "testd.conf" "\$n1"
	fi
	if [ \$cont1 -ne 0 ]; then
		if [ \$n2 -ge \$cont1 ]; then
			n2=1
		else
			n2=\$[ n2 + 1 ]
		fi
		tempo_principal "\$mesconfiguracao" "-f6" "-f5" "-f4" "-f3" "-f2" "\$n2"
		ativador_principal "\$ano" "\$mesek" "\$semanak" "\$dia_d" "2" "\$tempok" "testm.conf" "\$n2"
	fi
	if [ \$cont2 -ne 0 ]; then
		if [ \$n3 -ge \$cont2 ]; then
			n3=1
		else
			n3=\$[ n3 + 1 ]
		fi
		tempo_principal "\$anoconfiguracao" "-f7" "-f6" "-f5" "-f4" "-f3" "\$n3"
		ativador_principal "\$anok" "\$mesek" "\$semanak" "\$dia_d" "3" "\$tempok" "testa.conf" "\$n3"
	fi
	sleep 1.5
done

exit 0
EOF
		cat <<EOF > $pastaj/mostrador.sh
#!$SHELL

agenda="\$1"
n="\$2"

if [ "\$USER" = "root" ]; then
	user=\$SUDO_USER
else
	user=\$USER
fi

pasta_conficuracao=/home/\$user/.Agendador

imprime_agendamento(){
	q=\$1 ; r=\$2
	titulo="TAREFA AGENDADA - \$r"
	texto=\$(sed -n "\$n,\$n p" \$pasta_conficuracao/descricao\$q.conf)
	cont2="\$[\${#texto} + 4]"
	cont1="\$[\${#titulo} + 4]"
	if [ \$cont1 -ge \$cont2 ]; then
		cont=\$cont1
	else
		cont=\$cont2
	fi
	retorno=("\$titulo" "\$texto" "\$cont")
}

case \$agenda in 
	1) imprime_agendamento "d" "SEMANAL" ;;
	2) imprime_agendamento "m" "MENSAL" ;;
	3) imprime_agendamento "a" "ANUAL" ;;
esac

dialog --colors --title "\Zr\Z1  \${retorno[0]}                          
              \Zn" --msgbox "\${retorno[1]}" 6 \${retorno[2]} 
clear

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
		
		cp /usr/share/applications/agendador.desktop /home/$user/Desktop
		display_principal "Os atalhos na Àrea de trabalho foram criados..."
		chmod +x $pastaj/*.sh /usr/share/applications/*.desktop ; chmod 775 /home/$user/Desktop/*.desktop
		chown $user:$user /home/$user/Desktop/*.desktop
		cat /home/$user/.desktop-session/startup | grep -q "$pastaj/temporalizador.sh &"
		if [ "$?" = "1" ]; then
			sed '/^$/d' /home/$user/.desktop-session/startup > /home/$user/.desktop-session/temp.conf
			mv /home/$user/.desktop-session/temp.conf /home/$user/.desktop-session/startup
			echo "$pastaj/temporalizador.sh &" >> /home/$user/.desktop-session/startup
			chmod +x /home/$user/.desktop-session/startup ; chown $user:$user /home/$user/.desktop-session/startup
			display_principal "Configuração será instalada no Startup..."
		else
			display_principal "A configuração encontrada e não será instalada..."
		fi
		pkill temporalizador. ; display_principal "Temporizador \Z2iniciado\Zn..." 6
		bash -c "$pastaj/temporalizador.sh" & 
		reset ; exit 0
		;;
		2)
		pkill temporalizador. ; display_principal "Temporizador \Z1finalizado\Zn..." 6
		if [ -d "$pastaj" ]; then
			display_principal "O diretório Agendador será removido..." ; rm -rf $pastaj
		else
			display_principal "O diretório Agendador não encontrado..."
		fi
		clear
		if [ -d "$pastab" ]; then
			display_principal "O diretório ../pixmaps/Agendador será removido..."
			rm -rf /usr/share/pixmaps/Agendador
		else
			display_principal "O diretório ../pixmaps/Agendador não encontrado..."
		fi
		clear
		if [ -d "$pastaa" ]; then
			display_principal "O diretório /home/$user/.Agendador será removido..."
			rm -rf $pastaa
		else
			display_principal "O diretório /home/$user/.Agendador não encontrado..."
		fi
		clear
		if [ -e "/usr/share/applications/agendador.desktop" ]; then
			display_principal "O arquivo ../applications/agendador.desktop será removido..."
			rm /usr/share/applications/agendador.desktop
		else
			display_principal "O arquivo ../applications/agendador.desktop não encontrado..."
		fi
		clear
		if [ -e "/home/$user/Desktop/agendador.desktop" ]; then
			display_principal "O arquivo ../Desktop/agendador.desktop será removido..."
			rm /home/$user/Desktop/agendador.desktop
		else
			display_principal "O arquivo ../Desktop/agendador.desktop não encontrado..."
		fi
		clear
		cat /home/$user/.desktop-session/startup | grep -q "$pastaj/temporalizador.sh &"
		if [ "$?" = "1" ]; then
			display_principal "Configuração não encontrada.."
		else
			display_principal "A configuração será deletada..."
			awk -F "$pastaj/temporalizador.sh &" '{print $1}' /home/$user/.desktop-session/startup > /home/$user/.desktop-session/temp.conf
			mv /home/$user/.desktop-session/temp.conf /home/$user/.desktop-session/startup
			sed '/^$/d' /home/$user/.desktop-session/startup > /home/$user/.desktop-session/temp.conf 
			mv /home/$user/.desktop-session/temp.conf /home/$user/.desktop-session/startup
			chmod +x /home/$user/.desktop-session/startup ; chown $user:$user /home/$user/.desktop-session/startup
			display_principal "Os arquivos foram removidos..."
		fi
		reset ; exit 0 ;;
		3) display_principal "Saindo do instalador..." ; reset ; exit 0 ;;
		*) display_principal "Instalação cancelada..." ; reset ; exit 0 ;;
	esac	
}

menu
