#!/bin/bash
input="dados-setores.csv"
rm texto.txt

while IFS=',' read -r f1
do
       if cat /etc/samba/smb.conf | grep -q "$f1"; then
                echo Compartilhamento do grupo "$f1" já está criado
       else
			upper=$(echo "$f1" | tr [:lower:] [:upper:])
			
			#cria o diretorio do compartilhamento e muda o grupo do diretorio
			mkdir /srv/arquivos/samba/"$f1"
			chgrp "$f1" /srv/arquivos/samba/"$f1"
			
			#adiciona o compartilhamento ao smb.conf
			echo ''
			echo ["$f1"] >> /etc/samba/smb.conf
			echo path = /srv/arquivos/samba/"$f1" 
			echo read only = no 
			echo force create mode = 660 
			echo force directory mode = 750 
			echo hide files = /*.ini /*.log / 
			echo valid users = @"$f1" 
			echo public = no 
			echo browseable = no 	
			echo ''
			
			#cria o texto a ser inserido do script de logon "logon.vbs", que está na máquina adserver
			touch texto.txt
			echo Case \""$upper"\" >> texto.txt
            echo '    'objNetwork.RemoveNetworkDrive \"G\",\"true\" >> texto.txt
            echo '    'objNetwork.MapNetworkDrive \"G:\",\"\\\\storage\\"$f1"\",\"true\" >> texto.txt
			echo End Select >> texto.txt
 		
        fi
done < "$input"


