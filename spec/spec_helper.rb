require 'serverspec'
require 'pathname'
require 'net/ssh'
require 'yaml'

include SpecInfra::Helper::Ssh
include SpecInfra::Helper::DetectOS
# set :backend, :exec

set_property YAML.load_file('group_vars/all.yml')
