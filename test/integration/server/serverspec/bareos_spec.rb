require 'spec_helper'

describe package('bareos-director') do
  it { should be_installed }
end

describe service('bareos-dir') do
  it { should be_enabled }
  it { should be_running }
end

describe package('bareos-storage') do
  it { should be_installed }
end

describe service('bareos-sd') do
  it { should be_enabled }
  it { should be_running }
end

describe package('bareos-filedaemon') do
  it { should be_installed }
end

describe service('bareos-fd') do
  it { should be_enabled }
  it { should be_running }
end
