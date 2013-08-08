# You can ask for more memory and cores when creating your Vagrant machine:
# RAILS_VAGRANT_MEMORY=1536 RAILS_VAGRANT_CORES=4 vagrant up
MEMORY = ENV['RAILS_VAGRANT_MEMORY'] || '512'
CORES = ENV['RAILS_VAGRANT_CORES'] || '2'

Vagrant.configure("2") do |config|

  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  config.vm.network :private_network, ip: '192.168.11.14'
  config.ssh.max_tries = 40
  config.ssh.timeout   = 120

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ['cookbooks', 'site-cookbooks']

    chef.json = {
      :rbenv => {
        :user_installs => [
          { :user         => 'vagrant',
            :rubies       => ['2.0.0-p247', '1.9.3-p448'],
            :global       => '2.0.0-p247',
            :gems         => {
              '2.0.0-p247' => [
                {:name    => 'bundler'}
              ],
              '1.9.3-p448' => [
                {:name    => 'bundler'}
              ]
            }
          }
        ]
      },
      :mysql => {
        :server_root_password => "nonrandompasswordsaregreattoo",
        :server_repl_password => "nonrandompasswordsaregreattoo",
        :server_debian_password => "nonrandompasswordsaregreattoo"
      },
      :postgresql => {
        :password => {
          :postgres => "md5598fedc3550ad4ecad4ec14aa7992e82"
        },
        :clear_password => {
          :postgres => "nonrandompasswordsaregreattoo"
        },
        :config => {
          :lc_messages => 'en_US.UTF-8',
          :lc_monetary => 'en_US.UTF-8',
          :lc_numeric => 'en_US.UTF-8',
          :lc_time => 'en_US.UTF-8',
        }
      }
    }

    chef.run_list = %w{
      recipe[zsh]
      recipe[locale]
      recipe[ruby_build]
      recipe[rbenv::vagrant]
      recipe[rbenv::user]
      recipe[java]
      recipe[mysql::server]
      recipe[mysql::ruby]
      recipe[java]
      recipe[rails::vagrant]
    }
  end

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", MEMORY.to_i]
    v.customize ["modifyvm", :id, "--cpus", CORES.to_i]
  end
end
