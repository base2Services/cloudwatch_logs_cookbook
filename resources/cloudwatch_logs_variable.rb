resource_name :cloudwatch_logs_variable
property :variable_name, String, name_property: true
property :code, kind_of: String

action :create do
  directory '/etc/awslogs/vars.d' do
    mode '0644'
    recursive true
    action :create
  end

  file "/etc/awslogs/vars.d/#{variable_name}" do
    content "#{code}\n"
      mode '0644'
    action :create
  end
end
