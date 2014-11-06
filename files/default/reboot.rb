# encoding: UTF-8

class Chef
  class Handler
    class Reboot < Chef::Handler # rubocop:disable Documentation
      def initialize
      end

      def success?
        run_status.success?
      end

      def enabled?
        node.roles.include? node['reboot-handler']['enabled_role']
      end

      def should_reboot?
        node.run_state['reboot']
      end

      def post_boot_runlist?
        node['reboot-handler']['post_boot_runlist']
      end

      def post_boot_runlist
        node.run_list.reset! node['reboot-handler']['post_boot_runlist']
        node.save
      end

      def report
        return unless success?
        return unless enabled?
        return unless should_reboot?
        post_boot_runlist if post_boot_runlist?

        Mixlib::ShellOut.new(node['reboot-handler']['command']).run_command
      end
    end
  end
end
