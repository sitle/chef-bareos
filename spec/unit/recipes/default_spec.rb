#
# Cookbook Name:: chef-bareos
# Spec:: default
#
# Copyright (C) 2016 Leonard TAVAE

require 'spec_helper'

describe 'chef-bareos::default' do
  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
  end
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on an #{platform.capitalize}-#{version} box" do
        let(:chef_run) do
          runner = ChefSpec::ServerRunner.new(platform: platform, version: version)
          runner.converge(described_recipe)
        end
        let(:template) { chef_run.template('/etc/bareos/bareos-fd.conf') }
        let(:execute) { chef_run.execute('restart-fd') }
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
        when 'centos', 'redhat'
          it 'adds the yum repo bareos' do
            expect(chef_run).to create_yum_repository('bareos')
          end
          it 'adds the yum repo bareos_contrib' do
            expect(chef_run).to create_yum_repository('bareos_contrib')
          end
        end
        it 'includes the `chef-bareos::client` recipe' do
          expect(chef_run).to include_recipe('chef-bareos::client')
          chef_run
        end
        it 'installs the bareos-filedaemon package' do
          expect(chef_run).to install_package('bareos-filedaemon')
        end
        it 'renders the bareos-fd config' do
          expect(chef_run).to create_template('/etc/bareos/bareos-fd.conf').with(
            user:   'root',
            group:  'bareos',
            mode:   '0640',
            sensitive: true
          )
        end
        it 'creates the execute[restart-fd], subscribes to bareos-fd template, notifies bareos-fd to restart' do
          expect(chef_run).to_not run_execute('restart-fd')
          expect(execute).to subscribe_to('template[/etc/bareos/bareos-fd.conf]')
          expect(execute).to notify('service[bareos-fd]').to(:restart)
        end
        it 'enables and starts the bareos-fd service' do
          expect(chef_run).to enable_service('bareos-fd')
          expect(chef_run).to start_service('bareos-fd')
        end
      end
    end
  end
end
