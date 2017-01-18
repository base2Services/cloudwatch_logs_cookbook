require 'inspec'

describe file('/etc/init/awslogs.conf') do
  it { should exist }
  it { should be_file }
  its('content') { should match /description "Configures and starts CloudWatch Logs agent"/ }
end

describe file('/etc/awslogs/awscli.conf.tmpl') do
  it { should exist }
  it { should be_file }
  its('content') { should match /plugin/ }
end

describe file('/etc/awslogs/awscli.conf') do
  it { should exist }
  it { should be_file }
  its('content') { should match /plugin/ }
end

describe upstart_service('awslogs') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/awslogs/config/messages') do
  it { should exist }
  it { should be_file }
  its('content') { should match /log_group_name = ap-southeast-2/ }
end
