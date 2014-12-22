require 'spec_helper'

describe command('php -v | grep PHP') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /5.5.*/ }
end

describe 'PHP config parameters' do
  context php_config('memory_limit') do
    its(:value) { should eq '128M' }
  end

  context php_config('error_reporting') do
    its(:value) { should eq 32767 }
  end

  context php_config('display_errors') do
    its(:value) { should eq 1 }
  end

  context php_config('post_max_size') do
    its(:value) { should eq '36M' }
  end

  context php_config('upload_max_filesize') do
    its(:value) { should eq '36M' }
  end

  context  php_config('default_charset') do
    its(:value) { should eq 'UTF-8' }
  end

  context  php_config('mbstring.language') do
    its(:value) { should eq 'neutral' }
  end

  context  php_config('mbstring.internal_encoding') do
    its(:value) { should eq 'UTF-8' }
  end

  context php_config('date.timezone') do
    its(:value) { should eq 'UTC' }
  end

  context php_config('session.save_path') do
    its(:value) { should eq '/tmp' }
  end

  context php_config('default_mimetype') do
    its(:value) { should match /text\/html/ }
  end

end
