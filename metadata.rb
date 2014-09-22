name             'bareos'
maintainer       'dsi'
maintainer_email 'leonard.tavae@informatique.gov.pf'
license          'All rights reserved'
description      'Installs/Configures bareos'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

supports 'centos', '>= 6.0'
supports 'debian', '>= 7.0'
supports 'ubuntu', '= 12.04'

depends 'yum', '=3.3.2'
depends 'apt', '=2.6.0'
depends 'openssl', '=2.0.0'
