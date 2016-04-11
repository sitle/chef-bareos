name 'chef-bareos'
maintainer 'dsi'
maintainer_email 'leonard.tavae@informatique.gov.pf'
license 'Apache 2.0'
description 'Installs/Configures bareos'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '2.2.16'

%w( centos redhat ).each do |os|
  supports os, '>= 6.0'
end

%w( fedora debian ubuntu ).each do |os|
  supports os
end

depends 'apt', '~> 3.0.0'
depends 'openssl', '~> 4.4.0'
depends 'postgresql', '~> 3.4.24'
depends 'yum', '~> 3.10.0'
depends 'yum-epel', '~> 0.6.6'
