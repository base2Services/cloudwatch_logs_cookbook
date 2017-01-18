if defined?(ChefSpec)
  def create_function(function_name)
    ChefSpec::Matchers::ResourceMatcher.new(:cloudwatch_logs_function, :create, function_name)
  end
  def installs_cloudwatch_log_agent(state_file)
    ChefSpec::Matchers::ResourceMatcher.new(:cloudwatch_logs_agent, :install, state_file)
  end
end
