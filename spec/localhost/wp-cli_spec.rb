require 'spec_helper'

describe command('wp --version') do
  let(:disable_sudo) { true }
  its(:exit_status) { should eq 0 }
end
