Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/jammy64"
  config.vm.hostname = "devops-lab"

  config.vm.network "private_network", ip: "192.168.56.10"

  # Mac (Parallels)
  config.vm.provider "parallels" do |p|
    p.memory = 6144
    p.cpus = 3
  end

  # Windows (VMware)
  config.vm.provider "vmware_desktop" do |v|
    v.memory = 6144
    v.cpus = 3
  end

  # shared workspace
  config.vm.synced_folder ".", "/home/vagrant/devops-lab"

  # Ansible provisioning
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible/playbook.yml"
  end

end