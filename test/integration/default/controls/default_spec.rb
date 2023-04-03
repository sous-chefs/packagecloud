describe command('ls /usr/local/bin/jake') do
  its(:exit_status) { should eq 0 }
end

describe command('/usr/local/bin/jake') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should eq "as it so happens, jake douglas is a very nice young man.\n" }
end

describe package('packagecloud-test') do
  it { should be_installed }
end
