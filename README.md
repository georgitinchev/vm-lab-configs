# VM Lab

DevOps & Pentest environments via Vagrant on VMware Fusion (Mac) or Workstation (Windows/WSL).

## Prerequisites

### macOS
- VMware Fusion
- Vagrant
- vagrant-vmware-desktop plugin: `vagrant plugin install vagrant-vmware-desktop`

### Windows (WSL2)
- VMware Workstation installed on Windows
- WSL2 with Ubuntu
- Vagrant VMware Utility service running on Windows (see WSL Setup below)

---

## Quick Start

### Ubuntu DevOps

```bash
VM_TYPE=ubuntu vagrant up
./scripts/export-vm.sh ubuntu
open ~/VMware-Labs/ubuntu-vm/ubuntu-24.04-aarch64.vmx  # macOS
# Windows: File > Open in VMware Workstation > C:\Users\<you>\VMware-Labs\ubuntu-vm\*.vmx
```

### Kali Pentest

```bash
VM_TYPE=kali vagrant up
./scripts/export-vm.sh kali
open ~/VMware-Labs/kali-vm/kalilinux-*.vmx  # macOS
# Windows: File > Open in VMware Workstation > C:\Users\<you>\VMware-Labs\kali-vm\*.vmx
```

Login: `vagrant` / `kali` (auto-login with GNOME/Xfce GUI)

---

## VMs

**Ubuntu 24.04** — 8GB RAM, 4 vCPU, 192.168.56.10, GNOME Desktop
- Docker, kubectl, Helm, kind, Terraform, Ansible, ArgoCD, AWS CLI, gcloud, VS Code

**Kali Linux** — 6GB RAM, 3 vCPU, 192.168.56.20, Xfce Desktop
- Nmap, Metasploit, Burp Suite, OWASP ZAP, Shodan, Amass, Subfinder, Wireshark, Hydra, John, Hashcat

---

## Commands

```bash
VM_TYPE=ubuntu vagrant up      # Create & provision
vagrant ssh                    # SSH
vagrant halt                   # Stop
vagrant destroy                # Delete
```

---

## WSL2 Setup (Windows only)

One-time setup before running `vagrant up` for the first time.

### 1 — Install Vagrant in WSL2

```bash
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vagrant -y
```

### 2 — Install Ansible in WSL2

```bash
sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
```

### 3 — Install Vagrant VMware plugin in WSL2

```bash
vagrant plugin install vagrant-vmware-desktop
```

### 4 — Install Vagrant VMware Utility on Windows

Download and install the Windows utility from:
```
https://developer.hashicorp.com/vagrant/install/vmware
```

Then in **PowerShell as Administrator** (Or via services.msc ensure), set it to auto-start:
```powershell
Set-Service -Name "VagrantVMware" -StartupType Automatic
Start-Service -Name "VagrantVMware"
```

### 5 — Allow WSL2 to reach the utility (port 9922)

The utility binds to Windows localhost only, so we need two things:

**In PowerShell as Administrator on Windows:**
```powershell
# Get your WSL interface IP
Get-NetIPAddress -InterfaceAlias "vEthernet (WSL*)" -AddressFamily IPv4 | Select-Object IPAddress

# Forward port 9922 to WSL (replace 172.x.x.x with the IP from above)
netsh interface portproxy add v4tov4 listenport=9922 listenaddress=0.0.0.0 connectport=9922 connectaddress=127.0.0.1

# Open firewall for WSL subnet
New-NetFirewallRule -DisplayName "Vagrant VMware Utility WSL" -Direction Inbound -Protocol TCP -LocalPort 9922 -RemoteAddress "172.16.0.0/12" -Action Allow
```

**In WSL2 — install socat and tunnel the port:**
```bash
sudo apt install socat -y
```

### 6 — Configure WSL2 environment

Add the following to your `~/.bashrc` (replace values with yours):

```bash
# Vagrant WSL config
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
export VAGRANT_DEFAULT_PROVIDER="vmware_workstation"
export BOX_ARCH="amd64"
export VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH="/mnt/c/Users/<your-windows-username>"

# Tunnel Vagrant VMware Utility port from Windows into WSL
# Replace 172.x.x.x with your WSL interface IP from step 5
if ! nc -z 127.0.0.1 9922 2>/dev/null; then
  socat TCP-LISTEN:9922,fork,reuseaddr TCP:172.x.x.x:9922 &>/dev/null &
fi
```

Then reload:
```bash
source ~/.bashrc
```

### 7 — Verify everything

```bash
vagrant --version                          # Vagrant 2.x.x
ansible --version                          # ansible [core 2.x.x]
vagrant plugin list                        # vagrant-vmware-desktop
echo $VAGRANT_DEFAULT_PROVIDER            # vmware_workstation
echo $VAGRANT_WSL_ENABLE_WINDOWS_ACCESS  # 1
nc -zv 127.0.0.1 9922                    # succeeded!
vagrant validate                           # Vagrantfile validated successfully.
```

### 8 — Run

```bash
VM_TYPE=ubuntu vagrant up
# or
VM_TYPE=kali vagrant up
```

> **Note:** Keep your project on the Windows filesystem (`/mnt/c/...`), not inside WSL's home directory. VMware Workstation on Windows cannot access the WSL filesystem.