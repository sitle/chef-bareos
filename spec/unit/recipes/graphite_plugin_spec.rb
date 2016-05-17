#
# Cookbook Name:: chef-bareos
# Spec:: graphite_plugin_spec
#
# Copyright (C) 2016 Leonard TAVAE

require 'spec_helper'

describe 'chef-bareos::graphite_plugin' do
  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
  end
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on an #{platform.capitalize}-#{version} box" do
        let(:chef_run) do
          runner = ChefSpec::ServerRunner.new(platform: platform, version: version)
          runner.node.set['bareos']['plugins']['graphite']['config_path'] = '/etc/bareos'
          runner.node.set['bareos']['plugins']['graphite']['plugin_path'] = '/usr/sbin'
          runner.node.set['bareos']['plugins']['graphite']['mailto'] = 'bareos'
          runner.converge(described_recipe)
        end
        it 'converges successfully' do
          expect { chef_run }.to_not raise_error
        end
        it 'includes the `chef-bareos::repo` recipe' do
          expect(chef_run).to include_recipe('chef-bareos::repo')
          chef_run
        end
        case platform
        when 'ubuntu'
          it 'adds the apt repo bareos' do
            expect(chef_run).to add_apt_repository('bareos')
          end
          it 'adds the apt repo bareos_contrib' do
            expect(chef_run).to add_apt_repository('bareos_contrib')
          end
          it 'installs plugin dependencies' do
            expect(chef_run).to install_package(['python', 'python-bareos', 'python-requests', 'python-django'])
          end
        when 'centos', 'redhat'
          it 'adds the yum repo bareos' do
            expect(chef_run).to create_yum_repository('bareos')
          end
          it 'adds the yum repo bareos_contrib' do
            expect(chef_run).to create_yum_repository('bareos_contrib')
          end
          if version.to_i == 6
            it 'installs EL6 plugin dependencies' do
              expect(chef_run).to install_package(['python', 'python-bareos', 'python-requests', 'python-fedora-django'])
            end
          else
            it 'installs EL7 plugin dependencies' do
              expect(chef_run).to install_package(['python', 'python-bareos', 'python-requests', 'python-django'])
            end
          end
        end
        it 'verifies config_path is present' do
          expect(chef_run).to create_directory('/etc/bareos')
          chef_run
        end
        it 'creates the graphite-poller.conf via the template resource with attributes' do
          expect(chef_run).to create_template('/etc/bareos/graphite-poller.conf').with(
            user:                 'bareos',
            group:                'bareos',
            mode:                 '0740'
          )
          chef_run
        end
        it 'creates the bareos-graphite-poller.py remote_file with attributes' do
          expect(chef_run).to create_remote_file('/usr/sbin/bareos-graphite-poller.py').with(
            owner:                'bareos',
            group:                'bareos',
            mode:                 '0740'
          )
          chef_run
        end
        it 'creates the bareos_graphite_poller cronjob with attributes' do
          expect(chef_run).to create_cron('bareos_graphite_poller').with(
            minute:               '5',
            user:                 'bareos',
            mailto:               'bareos'
          )
          chef_run
        end
      end
    end
  end
end
