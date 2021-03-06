#!/bin/sh
# preload functions
source $(find ~ -name Linux-install-scripts 2>/dev/null)/functions.sh
[[ $FASE == "" ]] && FASE=smb-server

# Installing package
echo "Install packages for SMB"
sudo apt-get update -qq && sudo apt-get upgrade -qq
sudo apt-get install -qq git samba samba-common-bin

echo "set up smb"
if [[ $(grep -Ril "\[home\]" /etc/samba/smb.conf) == "/etc/samba/smb.conf" ]]; then
	echo  "home folder is already set in smb.conf: no changes made"
else
	echo "[home]
	path = ~
	writeable=Yes
	create mask=0777
	directory mask=0777
	public=no" | sudo tee /etc/samba/smb.conf -a
fi
echo "set password for smb"
sudo smbpasswd -a $USER
sudo systemctl restart smbd
echo "smb is set"
