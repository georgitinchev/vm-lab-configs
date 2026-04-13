if Vagrant::Util::Platform.windows?
  ENV['VAGRANT_DEFAULT_PROVIDER'] = 'vmware_workstation'
  ENV['BOX_ARCH'] = 'amd64'
elsif Vagrant::Util::Platform.darwin?
  ENV['VAGRANT_DEFAULT_PROVIDER'] = 'vmware_fusion'
  ENV['BOX_ARCH'] = 'arm64'
end

vm_type = ENV['VM_TYPE'] || 'ubuntu'
box_arch = ENV['BOX_ARCH']
is_fusion = Vagrant::Util::Platform.darwin?

Vagrant.configure("2") do |config|
  if vm_type == 'ubuntu'
    config.vm.box = "bento/ubuntu-24.04"
    config.vm.box_version = "202510.26.0"
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

  if is_fusion
    config.vm.provider "vmware_fusion" do |v|
      v.vmx["memsize"] = mem
      v.vmx["numvcpus"] = cpu
      v.vmx["disk.enableUUID"] = "TRUE"
    end
  else
    config.vm.provider "vmware_workstation" do |v|
      v.vmx["memsize"] = mem
      v.vmx["numvcpus"] = cpu
      v.vmx["disk.enableUUID"] = "TRUE"
    end
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible/#{vm_type}.yml"
    ansible.compatibility_mode = "2.0"
    ansible.become = (vm_type == 'ubuntu')
  end
end