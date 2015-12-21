require 'serverspec'
require 'pathname'
require 'net/ssh'
require 'yaml'

set :backend, :exec
set :backend, :ssh

set_property YAML.load_file('group_vars/all.yml')
