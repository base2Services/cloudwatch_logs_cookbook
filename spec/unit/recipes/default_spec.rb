#
# Cookbook Name:: cloudwatch_logs
# Spec:: default
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

# This cookbook as no default recipe, we test against the
# cookbook in test/fixtures/cookbooks/text

require 'spec_helper'

describe 'test::default' do
  context 'stepping into cloudwatch_logs_agent' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(step_into: 'cloudwatch_logs_agent')
      runner.converge(described_recipe)
    end

    it 'installs jq package' do
      expect(chef_run).to install_package('jq')
    end

    it 'creates upstart service' do
      expect(chef_run).to create_template('/etc/init/awslogs.conf')
    end

    it 'creates awscli conf template' do
      expect(chef_run).to create_template('/etc/awslogs/awscli.conf.tmpl')
    end

    it 'creates awslogs conf' do
      expect(chef_run).to create_file('/etc/awslogs/awslogs.conf').with_content(/state_file = \/var\/lib\/awslogs\/agent-state/)
    end

    it 'creates common functions' do
      expect(chef_run).to create_function('00-common').with_code(/function get_tag/)
    end

  end

  # How this would test when consumed externally
  context 'using cloudwatch_logs_agent resource' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new()
      runner.converge(described_recipe)
    end

    it 'creates motd' do
      expect(chef_run).to installs_cloudwatch_log_agent('agent')
    end
  end
end
