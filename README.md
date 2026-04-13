# VM Lab

DevOps & Pentest environments via Vagrant on VMware Fusion (Mac) or Workstation (Windows).

## Quick Start

### Ubuntu DevOps

```bash
VM_TYPE=ubuntu vagrant up
./scripts/export-vm.sh ubuntu
open ~/VMware-Labs/ubuntu-vm/ubuntu-24.04-aarch64.vmx
```

### Kali Pentest

```bash
VM_TYPE=kali vagrant up
./scripts/export-vm.sh kali
open ~/VMware-Labs/kali-vm/kalilinux-*.vmx
```

Login: `vagrant` / `kali` (auto-login with GNOME/Xfce GUI)

## VMs

**Ubuntu 24.04** - 8GB RAM, 4 vCPU, 192.168.56.10, GNOME Desktop

- Docker, kubectl, Helm, kind, Terraform, Ansible, ArgoCD, AWS CLI, gcloud, VS Code

**Kali Linux** - 6GB RAM, 3 vCPU, 192.168.56.20, Xfce Desktop

- Nmap, Metasploit, Burp Suite, OWASP ZAP, Shodan, Amass, Subfinder, Wireshark, Hydra, John, Hashcat

## Commands

```bash
VM_TYPE=ubuntu vagrant up      # Create & provision
vagrant ssh                    # SSH
vagrant halt                   # Stop
vagrant destroy                # Delete
```
