resource_name :cloudwatch_logs_file
property :log_file_name, String, name_property: true
property :log_group, kind_of: String
property :log_stream, kind_of: String
property :log_file, kind_of: String

action :create do
  directory '/etc/awslogs/files' do
    mode '0644'
    recursive true
    action :create
  end

  file "/etc/awslogs/files/#{log_file_name}" do
    content "[#{log_file_name}]\nlog_group_name = #{log_group}\nlog_stream_name = #{log_stream}\nfile = #{log_file}"
      mode '0644'
    action :create
  end
end
