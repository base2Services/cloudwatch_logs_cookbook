cloudwatch_logs_agent 'agent' do
  action [:install, :enable]
end

cloudwatch_logs_function 'test_function' do
  code <<-EOF
  function test_function() {
    echo 'test'
  }
  EOF
end

service 'awslogs' do
  provider Chef::Provider::Service::Upstart
  action [ :start ]
end
