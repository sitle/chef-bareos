name             'bareos'
maintainer       'dsi'
maintainer_email 'leonard.tavae@informatique.gov.pf'
license          'All rights reserved'
description      'Installs/Configures bareos'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "yum"
depends "postgresql"
