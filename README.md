# VM Lab

Two throwaway lab VMs, built with Vagrant and provisioned with Ansible:

- **ubuntu**: DevOps workstation (Docker, kubectl, Helm, kind, Terraform, Ansible, Argo CD, AWS CLI, gcloud, VS Code)
- **kali**: pentest box (Nmap, Metasploit, Burp, ZAP, sqlmap, Hydra, John, Hashcat, Wireshark, subfinder, amass)

Works on VMware Fusion (Mac, Apple Silicon), VMware Workstation (Windows) and libvirt/KVM (Linux).
The Vagrantfile picks the provider and box architecture from the host OS.

Ansible runs inside the guest (`ansible_local`), so the host only needs Vagrant and a hypervisor.
That's what makes Windows work without WSL2.

## VMs

| VM | Box | RAM / CPU | IP | Desktop |
|---|---|---|---|---|
| ubuntu | bento/ubuntu-24.04 | 8 GB / 4 | 192.168.56.10 | GNOME (Xorg) |
| kali | kalilinux/rolling, sT0wn/kalilinux_arm64 on ARM | 6 GB / 3 | 192.168.56.20 | Xfce |

Both auto-login as `vagrant`.

## Prerequisites

**macOS:** VMware Fusion, Vagrant, `vagrant plugin install vagrant-vmware-desktop`

**Windows:** VMware Workstation Pro, [Vagrant](https://developer.hashicorp.com/vagrant/install),
[Vagrant VMware Utility](https://developer.hashicorp.com/vagrant/install/vmware),
then `vagrant plugin install vagrant-vmware-desktop` from PowerShell

**Linux:**
```bash
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients virtinst
sudo usermod -aG libvirt,kvm $USER
vagrant plugin install vagrant-libvirt
```
Log out and back in after the `usermod`.

## Usage

```bash
VM_TYPE=ubuntu vagrant up
VM_TYPE=kali vagrant up
```
On Windows: `$env:VM_TYPE = "ubuntu"; vagrant up`

Then `vagrant ssh`, `vagrant halt`, `vagrant destroy` as usual.

### Export to a standalone VMware VM

Once provisioned, you can detach the VM from Vagrant and open it like any other VMware VM:

```bash
./scripts/export-vm.sh ubuntu
open ~/VMware-Labs/ubuntu-vm/*.vmx
```
On Windows: `.\scripts\export-vm.ps1 -VmType ubuntu`, then File > Open in Workstation.

VMs are full clones (`linked_clone = false`), so an exported VM doesn't depend on the box
in `~/.vagrant.d` and keeps working after `vagrant box prune`.

Export is VMware only. On Linux the VM stays Vagrant-managed, use `virsh` if you need the domain.

## kind

`k8s/kind-config.yaml` is a 1 control plane + 2 worker cluster for the ubuntu VM:

```bash
kind create cluster --config k8s/kind-config.yaml
```

## Notes

- Fusion and Workstation are tested end to end. The libvirt path is not, yet.
- The ubuntu VM uses Xorg instead of Wayland and installs `open-vm-tools-desktop`. Without both,
  GNOME on Fusion can come back from suspend to a black window.
- `config.vm.provision "shell", inline: "true"` in the Vagrantfile is on purpose. It works around a
  Vagrant race where `ansible_local` reads stale ssh info right after the private network comes up.
