 #!/bin/bash

###remove enterprise apt list###
echo
echo
echo
echo "Remove Enterprise apt list? "
read -p "DO NOT DO THIS IF YOU HAVE AN ENTERPRISE SUBSCRIPTION" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
cp /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.bak
sed '1 s/./#&/' /etc/apt/sources.list.d/pve-enterprise.list >/etc/apt/sources.list.d/pve-enterprise2.list
mv /etc/apt/sources.list.d/pve-enterprise2.list /etc/apt/sources.list.d/pve-enterprise.list
fi

###enable iommu###
echo
echo
echo
PS3='IOMMU Options: '
options=("Enable Intel" "Enable AMD" "Do not enable")
select opt in "${options[@]}"
do
    case $opt in
        "Enable Intel")
            echo "Enabling for Intel"
            cp /etc/default/grub /etc/default/grub.bak
            sed -i '9s/.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on"/' /etc/default/grub
            echo "Updating Grub..."
            update-grub &>grub.log
            echo "Grub update finished!"
            break
            ;;
        "Enable AMD")
            echo "Enabling for AMD"
            cp /etc/default/grub /etc/default/grub.bak
            sed -i '9s/.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_iommu=on"/' /etc/default/grub
            echo "Updating Grub..."
            update-grub &>grub.log
            echo "Grub update finished!"
            break
            ;;
        "Do not enable")
            echo "Skipping IOMMU..."
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

##edit modules##
echo
echo
echo
echo "Edit Modules?"
echo "ENTRIES TO BE ADD TO /etc/modules:"
echo "vfio"
echo "vfio_iommu_type1"
echo "vfio_pci"
echo "vfio_virqfd"

read -p "" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
cp /etc/modules /etc/modules.bak
echo vfio >> /etc/modules
echo vfio_iommu_type1 >> /etc/modules
echo vfio_pci >> /etc/modules
echo vfio_virqfd >> /etc/modules
fi

##Update Proxmox##
echo
echo
echo
read -p "Update Proxmox?" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
pveupgrade
fi

###remove subcription warning###
echo
echo
echo

echo "Remove Subscription warning? "
PS3='This will restart the web interface, and you will lose connection to your current web shell session if you run this'
options=("Remove" "Remove and Reboot" "Do not Remove")
select opt in "${options[@]}"
do
    case $opt in
        "Remove")
            echo "Removing..."
            sed -Ezi.bak "s/(Ext.Msg.show\(\{\s+title: gettext\('No valid sub)/void\(\{ \/\/\1/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js && systemctl restart pveproxy.service
            break
            ;;
        "Remove and Reboot")
            echo "Removing and Rebooting"
            sed -Ezi.bak "s/(Ext.Msg.show\(\{\s+title: gettext\('No valid sub)/void\(\{ \/\/\1/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js && systemctl restart pveproxy.service
            reboot now
            break
            ;;
        "Do not Remove")
            echo "Done!"
            echo "It is recommended to reboot your system!"
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
