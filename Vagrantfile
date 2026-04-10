Vagrant.configure("2") do |config|

  config.vm.hostname = "devops-lab"

  config.vm.network "private_network", ip: "192.168.56.10"

  # 🟢 PARALLELS (Mac M2 → ARM)
  config.vm.provider "parallels" do |p|
    config.vm.box = "bento/ubuntu-24.04"
    config.vm.box_version = "202510.26.0"

    p.memory = 6144
    p.cpus = 3
  end

  # 🔵 VMWARE (Windows → AMD64)
  config.vm.provider "vmware_desktop" do |v|
    config.vm.box = "bento/ubuntu-24.04"
    config.vm.box_version = "202510.26.0"

    v.memory = 6144
    v.cpus = 3
  end

  # Shared workspace
  config.vm.synced_folder ".", "/home/vagrant/devops-lab"

  # Ansible provisioning
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible/playbook.yml"
  end

end