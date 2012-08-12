class Reboot < Chef::Handler
  def initialize
  end

  def report
    ### If Chef ran successfully.
    if run_status.success?
      ### AND node is in the booted role.
        if node.roles.include? node['reboot-handler']['enabled_role']
        ### AND node has the reboot flag.
        if node.run_state['reboot']
          ### THEN reboot node.
          ::Chef::ShellOut.new node['reboot-handler']['reboot_command']
        end
      end
    end
  end
end
