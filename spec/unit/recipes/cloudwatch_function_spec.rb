#
# Cookbook Name:: cloudwatch_logs
# Spec:: cloudwatch_logs_function
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

# This cookbook as no default recipe, we test against the
# cookbook in test/fixtures/cookbooks/text

require 'spec_helper'

describe 'test::default' do
  context 'stepping into cloudwatch_logs_function' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(step_into: 'cloudwatch_logs_function')
      runner.converge(described_recipe)
    end

    it 'creates test functions' do
      expect(chef_run).to create_file('/etc/awslogs/functions/test')
    end
  end
end
