require "spec_helper"

path = os[:family].downcase == "ubuntu" ? "/usr/local/bin/jakedotrb" : "/usr/bin/jakedotrb"

describe command("ls #{path}") do
  it { should return_exit_status 0 }
end

describe command(path) do
  it { should return_exit_status 0 }
  it { should return_stdout(/jake douglas is a very nice young man./) }
end
