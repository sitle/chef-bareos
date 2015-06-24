# Repository

default['bareos']['url'] = 'http://download.bareos.org/bareos/release'
default['bareos']['version'] = 'latest'

if platform_family?('rhel')
  default['bareos']['yum_repository'] = 'bareos'
  default['bareos']['description'] = 'Backup Archiving Recovery Open Sourced Current stable'
end

case node['platform']
when 'ubuntu'
  default['bareos']['baseurl'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/xUbuntu_#{node['platform_version']}/"
  default['bareos']['gpgkey'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/xUbuntu_#{node['platform_version']}/Release.key"
when 'centos'
  default['bareos']['baseurl'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/CentOS_6/"
  default['bareos']['gpgkey'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/CentOS_6/repodata/repomd.xml.key"
else
  default['bareos']['baseurl'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/Debian_7.0/"
  default['bareos']['gpgkey'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/Debian_7.0/Release.key"
end

# Database
default['bareos']['database_type'] = 'postgresql' # postgresql/mysql
default['bareos']['dbdriver'] = 'postgresql'
default['bareos']['dbname'] = 'bareos'
default['bareos']['dbuser'] = 'bareos'
default['bareos']['dbpassword'] = ''

# Clients list
default['bareos']['clients'] = []

# Tape
default['bareos']['tape'] = false

# Director
default['bareos']['dir_port'] = 9101
default['bareos']['dir_max_concurrent_jobs'] = 20
default['bareos']['dir_subscription'] = nil
default['bareos']['dir_subs'] = nil
