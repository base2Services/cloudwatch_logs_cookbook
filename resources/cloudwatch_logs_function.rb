resource_name :cloudwatch_logs_function
property :function_name, String, name_property: true
property :code, kind_of: String

action :create do
  directory '/etc/awslogs/functions' do
    mode '0644'
    recursive true
    action :create
  end

  file "/etc/awslogs/functions/#{function_name}" do
    content "#{code}\n"
      mode '0644'
    action :create
  end
end
