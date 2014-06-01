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
