describe command('/usr/local/bin/jakedotrb') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match /jake douglas is a very nice young man./ }
end

describe command('gem list jakedotrb') do
  its('exit_status') { should eq 0 }
end
