# Include cookbook dependencies
# Install postgresql here to ensure set encoding 'en_US.UTF-8'
%w{ build-essential openssh xml zlib
    postgresql::config_initdb postgresql::server postgresql::ruby }.each do |requirement|
  ENV['LANGUAGE'] = ENV['LANG'] = ENV['LC_ALL'] = "en_US.UTF-8"
  include_recipe requirement
end

# Install required packages for rails
node['rails']['packages'].each do |pkg|
  package pkg
end

# Install sshkey gem into chef
chef_gem "sshkey" do
  action :install
end

# Create a $HOME/.ssh folder
directory "#{node['rails']['home']}/.ssh" do
  owner node['rails']['user']
  group node['rails']['group']
  mode 0700
end

# Generate and deploy ssh public/private keys
Gem.clear_paths

# Configure rails user to auto-accept localhost SSH keys
template "#{node['rails']['home']}/.ssh/config" do
  source "ssh_config.erb"
  owner node['rails']['user']
  group node['rails']['group']
  mode 0644
  variables(
    :fqdn => node['fqdn'],
    :trust_local_sshkeys => node['rails']['trust_local_sshkeys']
  )
end

# Clone rails repo from github
git node['rails']['app_home'] do
  repository node['rails']['rails_url']
  reference node['rails']['rails_branch']
  action :checkout
  user 'root'
end

# Database information
mysql_connexion = { :host     => 'localhost',
                    :username => 'root',
                    :password => node['mysql']['server_root_password'] }

postgresql_connexion = { :host     => 'localhost',
                         :username => 'postgres',
                         :password => node['postgresql']['clear_password']['postgres'] }

# Create mysql user rails
mysql_database_user 'rails' do
  connection mysql_connexion
  password ''
  action :create
end

postgresql_database_user 'rails' do
  connection postgresql_connexion
  password 'rails'
  action :create
end

postgresql_database postgresql_connexion[:username] do
  connection postgresql_connexion
  sql 'CREATE USER vagrant WITH CREATEUSER CREATEDB'
  action :query
  not_if %Q(PGPASSWORD=#{postgresql_connexion[:password]} psql -h localhost -U postgres -c "select * from pg_user" | grep -c #{node['rails']['user']})
end

# Create databases and users
%w{ activerecord_unittest activerecord_unittest2 }.each do |db|
  mysql_database "#{db}" do
    connection mysql_connexion
    action :create
  end

  postgresql_database "#{db}" do
    connection postgresql_connexion
    action :create
    encoding 'UTF-8'
    collation 'en_US.UTF-8'
  end

  # Undocumented: see http://tickets.opscode.com/browse/COOK-850
  postgresql_database_user 'rails' do
    connection postgresql_connexion
    database_name db
    action :grant
  end
end

# Grant all privelages on all databases/tables from localhost to rails
mysql_database_user 'rails' do
  connection mysql_connexion
  action :grant
end

# Append default Display (99.0) in bashrc
template "/etc/bash.bashrc" do
  owner "root"
  group "root"
  mode 0755
  source "bash.bashrc"
end

# Create directory for bundle options.
directory "#{node['rails']['home']}/.bundle" do
  owner node['rails']['user']
  group node['rails']['group']
  mode 0755
end

execute "rails-bundle-install" do
  command "su -l -c 'cd #{node['rails']['app_home']} && bundle install' vagrant"
  cwd node['rails']['app_home']
  user 'root'
end
