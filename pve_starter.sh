 #!/bin/bash

###remove subcription warning###
read -p "Remove Subscription warning? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
 sed -Ezi.bak "s/(Ext.Msg.show\(\{\s+title: gettext\('No valid sub)/void\(\{ \/\/\1/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js && systemctl restart pveproxy.service
fi

###remove enterprise apt list###
read -p "Remove Enterprise apt list? " -n 1 -r
echo (DO NOT DO THIS IF YOU HAVE AN ENTERPRISE SUBSCRIPTION)
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
cp /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.bak
sed '1 s/./#&/' /etc/apt/sources.list.d/pve-enterprise.list >/etc/apt/sources.list.d/pve-enterprise2.list
mv /etc/apt/sources.list.d/pve-enterprise2.list /etc/apt/sources.list.d/pve-enterprise.list
fi
