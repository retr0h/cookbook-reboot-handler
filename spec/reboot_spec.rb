require "chefspec"
require ::File.join ::File.dirname(__FILE__), "..", "files", "default", "reboot"

describe Reboot do
  ::Chef::ShellOut.class_eval do
    def run_command
      true
    end
  end

  before do
    @handler = ::Reboot.new
    @node = ::ChefSpec::ChefRunner.new.converge("reboot-handler::default").node
    @node.stub :save
    @run_status = ::Chef::RunStatus.new @node, Chef::EventDispatch::Dispatcher.new
  end

  it "doesn't reboot if the run failed" do
    @run_status.exception = ::Exception.new

    @handler.run_report_unsafe(@run_status).should_not be_true
  end

  it "doesn't reboot if the node does not have the enabled_role" do
    @handler.run_report_unsafe(@run_status).should_not be_true
  end

  it "doesn't reboot if the node has the enabled_role, but missing the reboot flag" do
    @node.roles << "booted"

    @handler.run_report_unsafe(@run_status).should_not be_true
  end

  describe "with enabled_role and reboot flag" do
    before do
      @node.roles << "booted"
      @node.run_state['reboot'] = true
    end

    it "reboots" do
      @handler.run_report_unsafe(@run_status).should be_true
    end

    it "issues correct reboot_command" do
      ::Chef::ShellOut.should_receive(:new).
        with("sync; sync; shutdown -r +1&").
        and_return({:run_command => true})

      @handler.run_report_unsafe(@run_status)
    end

    it "resets run_list if node has a post_boot_runlist attribute" do
      node = ::ChefSpec::ChefRunner.new do |n|
        n.set['reboot-handler']['post_boot_runlist'] = ["role[foo]"]
      end.converge("reboot-handler::default").node
      node.stub :save
      run_status = ::Chef::RunStatus.new node, Chef::EventDispatch::Dispatcher.new
      node.roles << "booted"
      node.run_state['reboot'] = true
      @handler.run_report_unsafe(run_status)

      node.run_list.to_s.should eq("role[foo]")
    end
  end
end
