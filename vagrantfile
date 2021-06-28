# -*- mode: ruby -*-
# vi: set ft=ruby sw=2 st=2 et :
# frozen_string_literal: true

SERVERS_COUNT = 2

Vagrant.configure('2') do |config|
  config.vm.box = 'debian/buster64'
  config.vm.box_check_update = false

  # Limiter la RAM des VM
  config.vm.provider 'virtualbox' do |vb|
    # vb.customize ['modifyvm', :id, '--cpuexecutioncap', '50']
    vb.memory = '2000'
    vb.cpus = 2
    vb.gui = false
  end

  # Mettre en place un cache pour APT
  # config.vm.synced_folder 'v-cache', '/var/cache/apt'

  config.vm.define 'control' do |machine|
    machine.vm.hostname = 'control'
    machine.vm.network 'private_network', ip: '192.168.50.250' # <<<< Corriger ICI
  end

  # 192.168.50.10
  # 192.168.50.20
  # 192.168.50.30
  SERVERS_COUNT.times do |idx|
    config.vm.define "server#{idx}" do |machine|
      machine.vm.hostname = "server#{idx}"
      machine.vm.network 'private_network', ip: "192.168.50.#{idx * 10 + 10}" # <<<<  Corriger ICI
      if idx.zero?
        machine.vm.network 'forwarded_port', guest: 80, host: 1080
        machine.vm.network 'forwarded_port', guest: 8080, host: 8080
      end
    end
  end

  config.vm.provision 'shell', path: 'provision.sh'
end

