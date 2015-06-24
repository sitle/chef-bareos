name 'chef-bareos'
maintainer 'dsi'
maintainer_email 'leonard.tavae@informatique.gov.pf'
license 'Apache 2.0'
description 'Installs/Configures bareos'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.2'

supports 'centos', '>= 6.0'
supports 'debian', '>= 7.0'
supports 'ubuntu'

depends 'apt'
depends 'openssl'
depends 'postgresql'
depends 'yum'
