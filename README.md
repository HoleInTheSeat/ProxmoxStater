# ProxmoxStater
Script for fresh Proxmox install

## What this script does (with prompts)
1. Disable PVE Enterprise app list
2. Enables iommu (may require extra work depending on your setup)
3. Updates Proxmox
4. Disable Subscritption warning message on login


## How to Run
bash <(curl -s https://raw.githubusercontent.com/HoleInTheSeat/ProxmoxStater/main/pve_starter.sh)

## Check your work
bash <(curl -s https://raw.githubusercontent.com/HoleInTheSeat/ProxmoxStater/main/check.sh)
