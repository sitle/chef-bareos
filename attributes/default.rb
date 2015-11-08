# Repository

default['bareos']['url'] = 'http://download.bareos.org/bareos/release'
default['bareos']['contrib_url'] = 'http://download.bareos.org/bareos/contrib'

# Used to have 'latest' as default, had potential update dangers
# default['bareos']['version'] = 'latest' <--- Could be dangerous, ***CAUTION***
default['bareos']['version'] = '14.2' # <--- Latest Stable version as of 6-26-15

if platform_family?('rhel', 'fedora')
  default['bareos']['yum_repository'] = 'bareos'
  default['bareos']['description'] = "Backup Archiving REcovery Open Sourced Current #{node['bareos']['version']}"
  default['bareos']['contrib_yum_repository'] = 'bareos_contrib'
  default['bareos']['contrib_description'] = "Backup Archiving REcovery Open Sourced Current #{node['bareos']['version']} contrib"
end

case node['platform_family']
when 'debian'
  case node['platform']
  when 'debian'
    default['bareos']['baseurl'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/Debian_#{node['platform_version'].to_i}.0/"
    default['bareos']['gpgkey'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/Debian_#{node['platform_version'].to_i}.0/Release.key"
    default['bareos']['contrib_baseurl'] = "#{node['bareos']['contrib_url']}/Debian_#{node['platform_version'].to_i}.0/"
    default['bareos']['contrib_gpgkey'] = "#{node['bareos']['contrib_url']}/Debian_#{node['platform_version'].to_i}.0/Release.key"
  when 'ubuntu'
    default['bareos']['baseurl'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/xUbuntu_#{node['platform_version']}/"
    default['bareos']['gpgkey'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/xUbuntu_#{node['platform_version']}/Release.key"
    default['bareos']['contrib_baseurl'] = "#{node['bareos']['contrib_url']}/xUbuntu_#{node['platform_version']}/"
    default['bareos']['contrib_gpgkey'] = "#{node['bareos']['contrib_url']}/xUbuntu_#{node['platform_version']}/Release.key"
  end
when 'rhel'
  case node['platform']
  when 'centos'
    default['bareos']['baseurl'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/CentOS_#{node['platform_version'].to_i}/"
    default['bareos']['gpgkey'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/CentOS_#{node['platform_version'].to_i}/repodata/repomd.xml.key"
    default['bareos']['contrib_baseurl'] = "#{node['bareos']['contrib_url']}/CentOS_#{node['platform_version'].to_i}/"
    default['bareos']['contrib_gpgkey'] = "#{node['bareos']['contrib_url']}/CentOS_#{node['platform_version'].to_i}/repodata/repomd.xml.key"
  when 'scientific'
    default['bareos']['baseurl'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/CentOS_#{node['platform_version'].to_i}/"
    default['bareos']['gpgkey'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/CentOS_#{node['platform_version'].to_i}/repodata/repomd.xml.key"
    default['bareos']['contrib_baseurl'] = "#{node['bareos']['contrib_url']}/CentOS_#{node['platform_version'].to_i}/"
    default['bareos']['contrib_gpgkey'] = "#{node['bareos']['contrib_url']}/CentOS_#{node['platform_version'].to_i}/repodata/repomd.xml.key"
  when 'redhat'
    default['bareos']['baseurl'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/#{node['platform_family'].upcase}_#{node['platform_version'].to_i}/"
    default['bareos']['gpgkey'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/#{node['platform_family'].upcase}_#{node['platform_version'].to_i}/repodata/repomd.xml.key"
    default['bareos']['contrib_baseurl'] = "#{node['bareos']['contrib_url']}/#{node['platform_family'].upcase}_#{node['platform_version'].to_i}/"
    default['bareos']['contrib_gpgkey'] = "#{node['bareos']['contrib_url']}/#{node['platform_family'].upcase}_#{node['platform_version'].to_i}/repodata/repomd.xml.key"
  end
when 'fedora'
  default['bareos']['baseurl'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/Fedora_20/"
  default['bareos']['gpgkey'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/Fedora_20/repodata/repomd.xml.key"
  default['bareos']['contrib_baseurl'] = "#{node['bareos']['contrib_url']}/Fedora_20/"
  default['bareos']['contrib_gpgkey'] = "#{node['bareos']['contrib_url']}/Fedora_20/repodata/repomd.xml.key"
else
  default['bareos']['baseurl'] = nil
  default['bareos']['gpgkey'] = nil
  default['bareos']['contrib_baseurl'] = nil
  default['bareos']['contrib_gpgkey'] = nil
end

# Messages
default['bareos']['messages']['mail_to'] = "bareos@#{node['domain']}"
default['bareos']['messages']['default_messages'] = 'Standard'
default['bareos']['messages']['default_admin_messages'] = 'all, !skipped, !restored'

# Database
default['bareos']['database']['catalog_name'] = 'MyCatalog'
default['bareos']['database']['database_type'] = 'postgresql' # postgresql/mysql
default['bareos']['database']['dbdriver'] = 'postgresql' # postgresql/mysql
default['bareos']['database']['dbname'] = 'bareos'
default['bareos']['database']['dbuser'] = 'bareos'
default['bareos']['database']['dbpassword'] = ''
default['bareos']['database']['dbaddress'] = nil

# Clients
default['bareos']['clients']['name'] = node['fqdn']

default['bareos']['clients']['fd_port'] = 9102
default['bareos']['clients']['max_concurrent_jobs'] = 20
default['bareos']['clients']['heartbeat_interval'] = 600

default['bareos']['clients']['client_search_query'] = 'roles:bareos_client'
default['bareos']['clients']['client_list'] = %w(node)
default['bareos']['clients']['bootstrap_file'] = '/var/lib/bareos/%c.bsr'
default['bareos']['clients']['jobdef_default_messages'] = node['bareos']['messages']['default_messages']
default['bareos']['clients']['jobdef_default_storage'] = 'File'
default['bareos']['clients']['jobdef_default_fileset'] = "#{node['fqdn']}-Fileset"
default['bareos']['clients']['storage'] = node['bareos']['clients']['jobdef_default_storage']

# Storage Daemon
default['bareos']['storage']['name'] = node['fqdn']
default['bareos']['storage']['storage_search_query'] = 'roles:bareos_storage'
default['bareos']['storage']['sd_port'] = 9103
default['bareos']['storage']['tape'] = false # Tape may have to be handled via custom wrapper cookbooks
default['bareos']['storage']['main_storage'] = 'File'
default['bareos']['storage']['servers'] = %w(node)
default['bareos']['storage']['sd_mon_enable'] = 'yes'
default['bareos']['storage']['max_concurrent_jobs'] = 20

# Director
default['bareos']['director']['name'] = node['fqdn']
default['bareos']['director']['dir_search_query'] = 'roles:bareos_director'
default['bareos']['director']['dir_port'] = 9101
default['bareos']['director']['dir_max_concurrent_jobs'] = 20
default['bareos']['director']['servers'] = %w(node)
default['bareos']['director']['console_commandacl'] = 'status, .status'
default['bareos']['director']['heartbeat_interval'] = 600

# Subscription Management (Director)
default['bareos']['director']['dir_subscription'] = nil
default['bareos']['director']['dir_subs'] = nil

# Workstation
default['bareos']['workstation']['name'] = node['fqdn']

##########################
# Example Default Hashes #
##########################

# General Client Config
default['bareos']['clients']['conf'] = {
  'FDPort' => '9102',
  'File Retention' => '30 days',
  'Job Retention' => '6 months',
  'AutoPrune' => 'yes',
  'Maximum Concurrent Jobs' => '20'
}

# Jobs
default['bareos']['clients']['jobs'] = {
  'JobDefs' => 'default-def'
}

# Job Definitions
default['bareos']['clients']['job_definitions']['default-def'] = {
  'Level' => 'Incremental',
  'Fileset' => 'default-fileset',
  'Schedule' => 'monthly',
  'Storage' => 'default-file-storage',
  'Messages' => 'Standard',
  'Pool' => 'default-file-pool',
  'Priority' => '10',
  'Write Bootstrap' => '"/var/lib/bareos/%c.bsr"',
  'SpoolData' => 'no'
}

# Filesets
default['baroes']['clients']['filesets']['default'] = {
  'options' => {
    'signature' => 'MD5'
  },
  'include' => {
    'File' => '/',
    'Exclude Dir Containing' => '.bareos_ignore'
  },
  'exclude' => {
    'File' => [
      '/var/lib/bareos',
      '/var/lib/bareos/storage',
      '/var/lib/pgsql',
      '/var/lib/mysql',
      '/proc',
      'tmp',
      '/.journal',
      '/.fsck',
      '/spool'
    ]
  }
}

# Pools
default['bareos']['clients']['pools']['default-file-pool'] = {
  'Pool Type' => 'Backup',
  'Recycle' => 'yes',
  'Volume Retention' => '30 days',
  'Maximum Volume Bytes' => '10G',
  'Maximum Volumes' => '25',
  'LabelFormat' => 'FileVolume-'
}

# Schedules
default['bareos']['clients']['schedules']['monthly'] = {
  'Description' => [
    'Default Monthly Schedule'
  ],
  'Run' => [
    'Full 1st sun at 23:05',
    'Differential 2nd-5th sun at 23:05',
    'Incremental mon-sat at 23:05'
  ],
  'Enabled' => [
    'yes'
  ]
}

# Storages
default['bareos']['clients']['storages']['default-file-storage'] = {
  'Address' => node['bareos']['storage']['name'], # N.B. Use a fully qualified name here
  'Device' => 'FileStorage',
  'Media Type' => 'File'
}
