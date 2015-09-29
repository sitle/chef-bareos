# Repository

default['bareos']['url'] = 'http://download.bareos.org/bareos/release'

# Used to have 'latest' as default, had potential update dangers
# default['bareos']['version'] = 'latest' <--- Could be dangerous, ***CAUTION***
default['bareos']['version'] = '14.2' # <--- Latest version as of 6-26-15

if platform_family?('rhel', 'fedora')
  default['bareos']['yum_repository'] = 'bareos'
  default['bareos']['description'] = 'Backup Archiving Recovery Open Sourced Current stable'
end

case node['platform_family']
when 'debian'
  case node['platform']
  when 'debian'
    default['bareos']['baseurl'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/Debian_#{node['platform_version']}/"
    default['bareos']['gpgkey'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/Debian_#{node['platform_version']}/Release.key"
  when 'ubuntu'
    default['bareos']['baseurl'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/xUbuntu_#{node['platform_version']}/"
    default['bareos']['gpgkey'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/xUbuntu_#{node['platform_version']}/Release.key"
  end
when 'rhel'
  default['bareos']['baseurl'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/#{node['platform']}_#{node['platform_version'].to_i}/"
  default['bareos']['gpgkey'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/#{node['platform']}_#{node['platform_version'].to_i}/repodata/repomd.xml.key"
when 'fedora'
  default['bareos']['baseurl'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/Fedora_20/"
  default['bareos']['gpgkey'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/Fedora_20/repodata/repomd.xml.key"
else
  default['bareos']['baseurl'] = nil
  default['bareos']['gpgkey'] = nil
end

# Database
default['bareos']['database']['catalog_name'] = 'MyCatalog'
default['bareos']['database']['database_type'] = 'postgresql' # postgresql/mysql
default['bareos']['database']['dbdriver'] = 'postgresql' # postgresql/mysql
default['bareos']['database']['dbname'] = 'bareos'
default['bareos']['database']['dbuser'] = 'bareos'
default['bareos']['database']['dbpassword'] = ''
# default['bareos']['database']['dbaddress'] = nil

# Clients
default['bareos']['clients']['fd_port'] = 9102
default['bareos']['clients']['max_concurrent_jobs'] = 20
default['bareos']['clients']['client_list'] = {} # Hashes are generally better
default['bareos']['clients']['file_retention'] = '30 days'
default['bareos']['clients']['job_retention'] = '6 months'
default['bareos']['clients']['autoprune'] = 'no'
default['bareos']['clients']['heartbeat_interval'] = 600
default['bareos']['clients']['jobdef_default_runlevel'] = 10
default['bareos']['clients']['jobdef_default_storage'] = 'File'
default['bareos']['clients']['jobdef_default_messages'] = 'Standard'
default['bareos']['clients']['jobdef_default_fileset'] = 'Full Set'
default['bareos']['clients']['jobdef_default_schedule'] = 'WeeklyCycle'
default['bareos']['clients']['host_pools'] = '0' # Default is disabled, normal pools, see below
default['bareos']['clients']['default_pool'] = 'Default'
default['bareos']['clients']['full_pool'] = 'Full-Pool'
default['bareos']['clients']['incremental_pool'] = 'Inc-Pool'
default['bareos']['clients']['differential_pool'] = 'Diff-Pool'
default['bareos']['clients']['enable_vfulls'] = false # Needs more work within host template

# Storage Daemon
default['bareos']['storage']['sd_port'] = 9103
default['bareos']['storage']['tape'] = false # Tape may have to be handled via custom wrapper cookbooks
default['bareos']['storage']['servers'] = {} # Use FQDN of each server for consistancy in solo mode
default['bareos']['storage']['custom_configs'] = '0'
default['bareos']['storage']['sd_mon_enable'] = 'yes'
default['bareos']['storage']['max_concurrent_jobs'] = 20

# Director
default['bareos']['director']['dir_port'] = 9101
default['bareos']['director']['dir_max_concurrent_jobs'] = 20
default['bareos']['director']['custom_configs'] = '1'
default['bareos']['director']['servers'] = {} # Use FQDN of each server for consistancy in solo mode

# Subscription Management (Director)
default['bareos']['director']['dir_subscription'] = nil
default['bareos']['director']['dir_subs'] = nil

# Messages
default['bareos']['messages']['mail_to'] = "bareos@#{node['domain_name']}"
default['bareos']['messages']['default_messages'] = 'Standard'

# Workstation
default['bareos']['workstation']['solo_mode'] = '0'
