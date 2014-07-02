require "spec_helper"

describe command('ls /usr/local/bin/jake') do
  it { should return_exit_status 0 }
end

describe command('/usr/local/bin/jake') do
  it { should return_exit_status 0 }
  it { should return_stdout("as it so happens, jake douglas is a very nice young man.") }
end

describe command('man jake') do
  it { should return_exit_status 0 }
  it { should return_stdout(/jake man page/) }
  it { should return_stdout(/binary executable program/) }
  it { should return_stdout(/No known bugs/) }
end

describe command('ls /home/vagrant/jake_1.0-7.dsc'), :if => os[:family] == 'Ubuntu' do
  it { should return_exit_status 0 }
end

describe command('ls /home/vagrant/jake_1.0.orig.tar.bz2'), :if => os[:family] == 'Ubuntu'  do
  it { should return_exit_status 0 }
end

describe command('ls /home/vagrant/jake_1.0-7.debian.tar.gz'), :if => os[:family] == 'Ubuntu' do
  it { should return_exit_status 0 }
end
