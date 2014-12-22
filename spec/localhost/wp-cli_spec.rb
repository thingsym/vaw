require 'spec_helper'

describe command('wp --version') do
  let(:disable_sudo) { true }
  let(:path) { '/usr/local/bin' }
  its(:exit_status) { should eq 0 }
end
