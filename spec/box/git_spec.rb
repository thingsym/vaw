require 'spec_helper'
require 'shellwords'

describe package('git') do
  it { should be_installed }
end
