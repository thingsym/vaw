require 'spec_helper'

describe command('composer --version') do
  let(:path) { '/usr/local/bin' }
  its(:exit_status) { should eq 0 }
end
