# Repository

default['bareos']['url'] = 'http://download.bareos.org/bareos/release'

# Used to have 'latest' as default, had potential update dangers
# default['bareos']['version'] = 'latest' <--- Could be dangerous, ***CAUTION***
default['bareos']['version'] = '14.2' # <--- Latest version as of 6-26-15

if platform_family?('rhel', 'fedora')
  default['bareos']['yum_repository'] = 'bareos'
  default['bareos']['description'] = "Backup Archiving REcovery Open Sourced Current #{node['bareos']['version']}"
end

case node['platform_family']
when 'debian'
  case node['platform']
  when 'debian'
    default['bareos']['baseurl'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/Debian_#{node['platform_version'].to_i}.0/"
    default['bareos']['gpgkey'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/Debian_#{node['platform_version'].to_i}.0/Release.key"
  when 'ubuntu'
    default['bareos']['baseurl'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/xUbuntu_#{node['platform_version']}/"
    default['bareos']['gpgkey'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/xUbuntu_#{node['platform_version']}/Release.key"
  end
when 'rhel'
  case node['platform']
  when 'centos'
    default['bareos']['baseurl'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/CentOS_#{node['platform_version'].to_i}/"
    default['bareos']['gpgkey'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/CentOS_#{node['platform_version'].to_i}/repodata/repomd.xml.key"
  when 'redhat'
    default['bareos']['baseurl'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/#{node['platform_family'].upcase}_#{node['platform_version'].to_i}/"
    default['bareos']['gpgkey'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/#{node['platform_family'].upcase}_#{node['platform_version'].to_i}/repodata/repomd.xml.key"
  end
when 'fedora'
  default['bareos']['baseurl'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/Fedora_20/"
  default['bareos']['gpgkey'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/Fedora_20/repodata/repomd.xml.key"
else
  default['bareos']['baseurl'] = nil
  default['bareos']['gpgkey'] = nil
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
default['bareos']['clients']['fd_port'] = 9102
default['bareos']['clients']['max_concurrent_jobs'] = 20
default['bareos']['clients']['client_list'] = {} # {'foo.bar.org','boo.ya.org'}
default['bareos']['clients']['file_retention'] = '30 days'
default['bareos']['clients']['job_retention'] = '6 months'
default['bareos']['clients']['autoprune'] = 'yes'
default['bareos']['clients']['heartbeat_interval'] = 600
default['bareos']['clients']['bootstrap_file'] = '/var/lib/bareos/%c.bsr'
default['bareos']['clients']['spool_data'] = 'no'
default['bareos']['clients']['jobdef_default_runlevel'] = 10
default['bareos']['clients']['jobdef_default_schedule'] = 'WeeklyCycle'
default['bareos']['clients']['jobdef_default_messages'] = node['bareos']['messages']['default_messages']
default['bareos']['clients']['jobdef_default_storage'] = 'File'
default['bareos']['clients']['jobdef_default_fileset'] = "#{node['fqdn']}-Fileset"
default['bareos']['clients']['storage'] = node['bareos']['clients']['jobdef_default_storage']
default['bareos']['clients']['fileset'] = node['bareos']['clients']['jobdef_default_fileset']
default['bareos']['clients']['host_pools'] = false # Default is disabled, normal pools, see below
case node['bareos']['clients']['host_pools']
when true
  default['bareos']['clients']['full_pool'] = "#{node['fqdn']}-Full-Pool"
  default['bareos']['clients']['incremental_pool'] = "#{node['fqdn']}-Inc-Pool"
  default['bareos']['clients']['differential_pool'] = "#{node['fqdn']}-Diff-Pool"
  default['bareos']['clients']['default_pool'] = "#{node['fqdn']}-Default-Pool"
when false
  default['bareos']['clients']['full_pool'] = 'File-Full-Pool'
  default['bareos']['clients']['incremental_pool'] = 'File-Inc-Pool'
  default['bareos']['clients']['differential_pool'] = 'File-Diff-Pool'
  default['bareos']['clients']['default_pool'] = 'File-Default-Pool'
end
default['bareos']['clients']['enable_vfulls'] = false
default['bareos']['clients']['vfull_pool'] = node['bareos']['clients']['full_pool']
default['bareos']['clients']['vfull_priority'] = 9
default['bareos']['clients']['vfull_accurate'] = 'no' # More sane option is no, yes is preferred if possible
default['bareos']['clients']['vfull_spool'] = 'no' # Not useful in most cases but available
default['bareos']['clients']['vfull_schedule'] = "#{node['fqdn']}-VFullSchedule"
default['bareos']['clients']['vfull_concurrent_jobs'] = 6
default['bareos']['clients']['vfull_duplicate_jobs'] = 'no'
default['bareos']['clients']['vfull_cancel_low_duplicates'] = 'yes'
default['bareos']['clients']['vfull_reschedule_on_fail'] = 'yes'
default['bareos']['clients']['vfull_reschedule_interval'] = '30 minutes'
default['bareos']['clients']['vfull_reschedule_times'] = 1

# Storage Daemon
default['bareos']['storage']['sd_port'] = 9103
default['bareos']['storage']['tape'] = false # Tape may have to be handled via custom wrapper cookbooks
case node['bareos']['storage']['tape']
when true
  default['bareos']['storage']['main_storage'] = 'TapeLibrary' # When enabled change to appropriate label in wrapper
when false
  default['bareos']['storage']['main_storage'] = 'File'
end
default['bareos']['storage']['servers'] = {} # Use FQDN of each server for consistancy in solo mode
default['bareos']['storage']['custom_configs'] = '0'
default['bareos']['storage']['sd_mon_enable'] = 'yes'
default['bareos']['storage']['max_concurrent_jobs'] = 20

# Director
default['bareos']['director']['dir_port'] = 9101
default['bareos']['director']['dir_max_concurrent_jobs'] = 20
default['bareos']['director']['custom_configs'] = true
default['bareos']['director']['servers'] = {} # Use FQDN of each server for consistancy in solo mode
default['bareos']['director']['console_commandacl'] = 'status, .status'
default['bareos']['director']['heartbeat_interval'] = 600

# Subscription Management (Director)
default['bareos']['director']['dir_subscription'] = nil
default['bareos']['director']['dir_subs'] = nil

# Workstation
default['bareos']['workstation']['solo_mode'] = '0'
