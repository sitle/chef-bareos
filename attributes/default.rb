# Dépôt
default['bareos']['yum_repository'] = 'bareos_bareos-13.2'
default['bareos']['description'] = 'Backup Archiving Recovery Open Sourced Current stable (CentOS_6)'
default['bareos']['baseurl'] = 'http://download.bareos.org/bareos/release/13.2/CentOS_6/'
default['bareos']['gpgkey'] = 'http://download.bareos.org/bareos/release/13.2/CentOS_6/repodata/repomd.xml.key'

# Database
default['bareos']['database_type'] = 'postgresql' # Peut-être mysql
default['bareos']['dbdriver'] = 'postgresql'
default['bareos']['dbname'] = 'bareos'
default['bareos']['dbuser'] = 'bareos'
default['bareos']['dbpassword'] = ''


# Director daemon
default['bareos']['dir_server'] = 'node1'
default['bareos']['dir_password'] = nil

# File daemon
default['bareos']['fd_password'] = nil

# Storage daemon
default['bareos']['sd_password'] = nil

# Monitor console password
default['bareos']['mon_password'] = nil

# Tape
default['bareos']['tape'] = 'disable'
