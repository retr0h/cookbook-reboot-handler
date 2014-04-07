# encoding: UTF-8

require_relative 'spec_helper'

describe 'reboot-handler::default' do
  before do
    Chef::Recipe.any_instance.stub(:require)
      .with('/var/chef/handlers/reboot')
  end
  let(:runner) { ChefSpec::Runner.new }

  it 'includes chef_handler' do
    Chef::Recipe.any_instance.should_receive(:include_recipe)
      .with('chef_handler')

    runner.converge(described_recipe)
  end

  it 'installs the handler' do
    chef_run = runner.converge(described_recipe)

    expect(chef_run).to create_cookbook_file '/var/chef/handlers/reboot.rb'
  end

  it "doesn't log" do
    chef_run = runner.converge(described_recipe)

    expect(chef_run).not_to write_log 'Unable to require the reboot handler!'
  end

  it 'logs when handler is missing' do
    Chef::Recipe.any_instance.should_receive(:require)
      .with('/var/chef/handlers/reboot')
      .and_raise LoadError.new
    chef_run = runner.converge(described_recipe)

    expect(chef_run).to write_log 'Unable to require the reboot handler!'
  end

  it 'chef_handler lwrp' do
    pending 'No idea how to test this'
  end
end
