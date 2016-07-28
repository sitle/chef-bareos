require 'spec_helper'

# Check Packages are installed
%w(bareos-filedaemon bareos-storage bareos-director).each do |bareos_pkgs|
  describe package(bareos_pkgs) do
    it { should be_installed }
  end
end

# Check if Bareos services are enabled and running
%w(bareos-fd bareos-sd bareos-dir).each do |bareos_srv|
  describe service(bareos_srv) do
    it { should be_enabled }
    it { should be_running }
  end
end

describe command('echo status director | bconsole') do
  its(:exit_status) { should eq 0 }
end

# Check if the graphite plugin was installed
%w(/etc/bareos/graphite-poller.conf /usr/sbin/bareos-graphite-poller.py).each do |plugin_files|
  describe file(plugin_files) do
    it { should be_file }
    it { should exist }
  end
end

describe file('/etc/bareos/graphite-poller.conf') do
  it { should contain '[director]' }
  it { should contain '[graphite]' }
end

describe file('/usr/sbin/bareos-graphite-poller.py') do
  it { should contain 'BAREOS' }
end

describe cron do
  it { should have_entry('* * * * *     /usr/sbin/bareos-graphite-poller.py    -c /etc/bareos/graphite-poller.conf').with_user('root') }
end
