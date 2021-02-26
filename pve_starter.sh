 #!/bin/bash

#remove subcription warning
sed -Ezi.bak "s/(Ext.Msg.show\(\{\s+title: gettext\('No valid sub)/void\(\{ \/\/\1/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js && systemctl restart pveproxy.service

#remove enterprise apt list
cp /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.bak
sed '1 s/./#&/' /etc/apt/sources.list.d/pve-enterprise.list >/etc/apt/sources.list.d/pve-enterprise2.list
mv /etc/apt/sources.list.d/pve-enterprise2.list /etc/apt/sources.list.d/pve-enterprise.list
