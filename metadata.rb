name              'chef-bareos'
maintainer        'dsi'
maintainer_email  'leonard.tavae@informatique.gov.pf'
license           'Apache 2.0'
description       'Installs/Configures BAREOS - Backup Archiving REcovery Open Sourced'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
issues_url        'https://github.com/sitle/chef-bareos/issues'
source_url        'https://github.com/sitle/chef-bareos.git'
version           '3.0.7'

depends 'apt', '>= 2.0'
depends 'openssl', '>= 4.0'
depends 'postgresql', '~> 4.0'
depends 'yum-epel', '>= 0.6'

supports 'debian', '>= 7.8'
supports 'ubuntu', '>= 12.04'
supports 'redhat', '>= 6.0'
supports 'centos', '>= 6.0'
