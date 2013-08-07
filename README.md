rails-vagrant-vm
================

Rails sandbox environment with vagrant. Recipes are managed by Chef.

Installation
------------

Clone this repo and install chef's necessary packages:

```
git clone
bundle install
bundle exec librarian-chef install
```

Then, start vm:

```
vagrant up
```

Finally vm started, you can test rails like:

```
cd /vagrant/rails/activesupport
bundle exec rake test
```

For more infomation: [Contributing to Ruby on Rails](http://guides.rubyonrails.org/contributing_to_ruby_on_rails.html)

Virtual Machine Management
----------------------------

When done just log out with `^D` and suspend the virtual machine

```bash
$ vagrant suspend
```

then, resume to hack again

```bash
$ vagrant resume
```

Run

```bash
$ vagrant halt
```

to shutdown the virtual machine, and

```bash
$ vagrant up
```

to boot it again.

You can find out the state of a virtual machine anytime by invoking

```bash
$ vagrant status
```

Finally, to completely wipe the virtual machine from the disk **destroying all its contents**:

```bash
$ vagrant destroy # DANGER: all is gone
```

System
--------

* Virtual Machine IP: 192.168.11.14
* User/password: vagrant/vagrant
* MySQL user/password: vagrant/Vagrant
* MySQL root password: nonrandompasswordsaregreattoo
* Postgresql user/password: postgres/nonrandompasswordsaregreattoo
* Postgresql user/password: rails/rails
* Postgresql user/password: vagrant/(no password)
* Ruby versions are 2.0.0-p247(default) and 1.9.3-p448 managed by rbenv

