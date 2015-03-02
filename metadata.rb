name 'reboot-handler'
maintainer 'John Dewey'
maintainer_email 'john@dewey.ws'
license 'Apache 2.0'
description 'Installs/Configures reboot-handler'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.0.1'

source_url  'https://github.com/retr0h/cookbook-reboot-handler/'
issues_url  'https://github.com/retr0h/cookbook-reboot-handler/issues'

recipe 'reboot-handler', 'Installs/Configures reboot-handler'

%w(debian ubuntu).each do |os|
  supports os
end

depends 'chef_handler'
