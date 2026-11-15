is_linux = Vagrant::Util::Platform.linux?
is_fusion = Vagrant::Util::Platform.darwin?

if Vagrant::Util::Platform.windows?
  ENV['VAGRANT_DEFAULT_PROVIDER'] ||= 'vmware_workstation'
  ENV['BOX_ARCH'] = 'amd64'
elsif is_fusion
  ENV['VAGRANT_DEFAULT_PROVIDER'] ||= 'vmware_fusion'
  ENV['BOX_ARCH'] = 'arm64'
elsif is_linux
  ENV['VAGRANT_DEFAULT_PROVIDER'] ||= 'libvirt'
  ENV['BOX_ARCH'] = 'amd64'
end

vm_type = ENV['VM_TYPE'] || 'ubuntu'
box_arch = ENV['BOX_ARCH']

Vagrant.configure("2") do |config|
  if vm_type == 'ubuntu'
    config.vm.box = "bento/ubuntu-24.04"
    # bento/ubuntu-24.04 202510.26.0 (Windows/macOS) has no libvirt build —
    # pin an older version that does for the Linux/libvirt path.
    config.vm.box_version = is_linux ? "202502.21.0" : "202510.26.0"
    config.vm.hostname = "devops-lab"
    config.vm.network "private_network", ip: "192.168.56.10"
    mem, cpu = "8192", "4"
  elsif vm_type == 'kali'
    if box_arch == 'arm64'
      config.vm.box = "sT0wn/kalilinux_arm64"
      config.vm.box_version = "2025.4"
    else
      config.vm.box = "kalilinux/rolling"
      config.vm.box_version = "2026.1.0"
    end
    config.vm.hostname = "kali-pentest"
    config.vm.network "private_network", ip: "192.168.56.20"
    mem, cpu = "6144", "3"
  end

  config.vm.synced_folder ".", "/tmp/lab", disabled: true

  # Full clone, not linked: the exported VM must not depend on the box in ~/.vagrant.d
  ["vmware_fusion", "vmware_workstation"].each do |p|
    config.vm.provider p do |v|
      v.linked_clone = false
      v.vmx["memsize"] = mem
      v.vmx["numvcpus"] = cpu
      v.vmx["disk.enableUUID"] = "TRUE"
    end
  end

  config.vm.provider "libvirt" do |v|
    v.memory = mem.to_i
    v.cpus = cpu.to_i
  end

  # No-op guest round-trip: forces Vagrant to refresh its cached ssh_info before
  # the ansible_local provisioner reads it. Without this, ansible_local can hit
  # a nil ssh_info race (Vagrant core bug) immediately after the private_network
  # step reconfigures the guest's adapters.
  config.vm.provision "shell", inline: "true"

  # Runs on the guest, not the host — Ansible has no native Windows control-node
  # support, so provisioning from a plain Windows/PowerShell host would fail here.
  config.vm.provision "file", source: "ansible", destination: "/tmp/ansible"

  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "ansible/#{vm_type}.yml"
    ansible.provisioning_path = "/tmp"
    ansible.compatibility_mode = "2.0"
    ansible.install = true
    ansible.become = (vm_type == 'ubuntu')
  end
end