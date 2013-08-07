# Set attributes for the git user
default['rails']['user'] = "vagrant"
default['rails']['group'] = "vagrant"
default['rails']['home'] = "/home/vagrant"
default['rails']['app_home'] = "/vagrant/rails"

# Set github URL for rails
default['rails']['rails_url'] = "git://github.com/rails/rails.git"
default['rails']['rails_branch'] = "master"

default['rails']['packages'] = %w{
  memcached vim curl wget checkinstall libxslt-dev
  libcurl4-openssl-dev libssl-dev libmysql++-dev postgresql-contrib
  libicu-dev libc6-dev libyaml-dev python python-dev nodejs
  xvfb xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic
}

