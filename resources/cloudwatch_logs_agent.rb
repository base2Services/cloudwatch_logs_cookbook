resource_name :cloudwatch_logs_agent
property :state_file, String, default: 'agent-state'

action :install do
  package ['jq','awslogs'] do
    timeout 30000
    action :install
  end

  directory '/etc/init' do
    mode '0644'
    recursive true
    action :create
  end

  directory '/etc/awslogs/config' do
    mode '0644'
    recursive true
    action :create
  end

  directory '/etc/awslogs/vars.d' do
    mode '0644'
    recursive true
    action :create
  end

  service 'awslogs' do
    action [ :disable ]
  end

  #remove sysv awslogs init
  file '/etc/init.d/awslogs' do
    action :delete
  end

  #creates upstart service config
  template '/etc/init/awslogs.conf' do
    cookbook 'cloudwatch_logs'
    source 'awslogs-service.conf.erb'
    mode '0644'
  end

  template '/etc/awslogs/awscli.conf.tmpl' do
    cookbook 'cloudwatch_logs'
    source 'awscli.conf.erb'
    mode '0644'
  end

  file '/etc/awslogs/awslogs.conf' do
    content <<-EOF
[general]
state_file = /var/lib/awslogs/#{state_file}
    EOF
    mode '0644'
  end

  cloudwatch_logs_function '00-common' do
    code <<-EOF
    function get_region {
      region="`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed s'/.$//'`"
      echo "$region"
    }
    function get_instance_id {
      instance_id="`curl -s http://169.254.169.254/latest/meta-data/instance-id -s`"
      echo "$instance_id"
    }
    function get_tag {
      region=`get_region`
      instance_id=`get_instance_id`
      tag="`aws ec2 describe-tags --region ${region} --filters "Name=resource-id,Values=$instance_id" "Name=key,Values=$1" --output=text | cut -f5`"
      echo "$tag"
    }
    EOF
    action :create
  end

  cloudwatch_logs_variable 'region' do
    code 'get_region'
  end

  cloudwatch_logs_file 'messages' do
    log_group '{region}'
    log_stream '{instance_id}/var/log/messages'
    log_file '/var/log/messages'
  end
end

action :enable do
  service 'awslogs' do
    provider Chef::Provider::Service::Upstart
    :enable
  end
end

action :disable do
  service 'awslogs' do
    provider Chef::Provider::Service::Upstart
    :disable
  end
end

action :start do
  service 'awslogs' do
    provider Chef::Provider::Service::Upstart
    :start
  end
end

action :stop do
  service 'awslogs' do
    provider Chef::Provider::Service::Upstart
    :start
  end
end

action :restart do
  service 'awslogs' do
    provider Chef::Provider::Service::Upstart
    :restart
  end
end
