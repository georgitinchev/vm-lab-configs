# VM Lab

DevOps & Pentest environments via Vagrant on VMware Fusion (Mac) or Workstation (Windows).

Provisioning runs entirely on the guest (`ansible_local`) — the host only needs
Vagrant and VMware installed, no Ansible, no WSL2, no port-forwarding. Same path
on both platforms.

## Prerequisites

### macOS
- VMware Fusion
- Vagrant
- vagrant-vmware-desktop plugin: `vagrant plugin install vagrant-vmware-desktop`

### Windows
- VMware Workstation Pro (free for personal use)
- Vagrant for Windows: https://developer.hashicorp.com/vagrant/install
- Vagrant VMware Utility: https://developer.hashicorp.com/vagrant/install/vmware
- vagrant-vmware-desktop plugin, from PowerShell: `vagrant plugin install vagrant-vmware-desktop`

Run everything from a plain PowerShell prompt — no WSL2 required.

---

## Quick Start

### Ubuntu DevOps

macOS:
```bash
VM_TYPE=ubuntu vagrant up
./scripts/export-vm.sh ubuntu
open ~/VMware-Labs/ubuntu-vm/ubuntu-24.04-aarch64.vmx
```

Windows (PowerShell):
```powershell
$env:VM_TYPE = "ubuntu"
vagrant up
.\scripts\export-vm.ps1 -VmType ubuntu
# File > Open in VMware Workstation > the .vmx path printed above
```

### Kali Pentest

macOS:
```bash
VM_TYPE=kali vagrant up
./scripts/export-vm.sh kali
open ~/VMware-Labs/kali-vm/kalilinux-*.vmx
```

Windows (PowerShell):
```powershell
$env:VM_TYPE = "kali"
vagrant up
.\scripts\export-vm.ps1 -VmType kali
# File > Open in VMware Workstation > the .vmx path printed above
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

macOS:
```bash
VM_TYPE=ubuntu vagrant up      # Create & provision
vagrant ssh                    # SSH
vagrant halt                   # Stop
vagrant destroy                # Delete
```

Windows (PowerShell):
```powershell
$env:VM_TYPE = "ubuntu"; vagrant up   # Create & provision
vagrant ssh                           # SSH
vagrant halt                          # Stop
vagrant destroy                       # Delete
```

---

## Windows Setup

One-time setup before running `vagrant up` for the first time. Everything here
runs in a plain PowerShell prompt — no WSL2, no port-forwarding, no firewall rules.

### 1 — Install Vagrant, VMware Workstation Pro, and the Vagrant VMware Utility

Download and install each from:
- Vagrant: https://developer.hashicorp.com/vagrant/install
- VMware Workstation Pro: https://www.vmware.com/products/workstation-pro.html
- Vagrant VMware Utility: https://developer.hashicorp.com/vagrant/install/vmware

### 2 — Install the Vagrant VMware plugin

```powershell
vagrant plugin install vagrant-vmware-desktop
```

### 3 — Verify

```powershell
vagrant --version                    # Vagrant 2.x.x
vagrant plugin list                  # vagrant-vmware-desktop
vagrant validate                     # Vagrantfile validated successfully.
```

### 4 — Run

```powershell
$env:VM_TYPE = "ubuntu"
vagrant up
# or
$env:VM_TYPE = "kali"
vagrant up
```

Ansible runs inside the guest (`ansible_local`) — nothing to install on the
Windows host beyond Vagrant, VMware, and the plugin above.