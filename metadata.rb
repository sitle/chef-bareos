name              'chef-bareos'
maintainer        'dsi'
maintainer_email  'leonard.tavae@informatique.gov.pf'
license           'Apache 2.0'
description       'Installs/Configures BAREOS - Backup Archiving REcovery Open Sourced'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '3.0.1'

%w( centos redhat ).each do |os|
  supports os, '>= 6.0'
end

%w( debian ubuntu ).each do |os|
  supports os
end

depends 'apt', '>= 2.0'
depends 'openssl', '>= 4.0'
depends 'postgresql', '~> 4.0'
depends 'yum-epel', '>= 0.6'
