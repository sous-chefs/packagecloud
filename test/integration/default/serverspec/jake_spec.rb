require "spec_helper"

describe command('ls /usr/local/bin/jake') do
  it { should return_exit_status 0 }
end

describe command('/usr/local/bin/jake') do
  it { should return_exit_status 0 }

  it do
    should return_stdout("as it so happens, jake douglas is a very nice young man.")
  end
end
