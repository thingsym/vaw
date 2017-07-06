require 'spec_helper'
require 'shellwords'

describe command('wp --version') do
  let(:disable_sudo) { true }
  its(:exit_status) { should eq 0 }
end
