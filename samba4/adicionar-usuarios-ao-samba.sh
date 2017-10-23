#!/bin/bash
input="/srv/samba/dados-servidores-samba.csv"

while IFS=',' read -r f1 f2 f3 f4 f5 f6 f7 f8
do
        if getent passwd "$f1" | grep -q "$f1"; then
                echo usuario $f1 já cadastrado
        else
          samba-tool user add "$f1" 123Mudar --given-name="$f2" --surname="$f3" --company="$f4" --job-title="$f5" --department="$f6"  --internet-address="$f7" --telephone-number=$"f8" --home-drive=H: --script-path=logon.vbs --home-directory=\\\\storage\\users\\"$f1" --profile-path=\\\\storage\\profiles\\"$f1"
          samba-tool  user  setpassword "$f1" --newpassword=123Mudar --must-change-at-next-login
        fi
done < "$input"
