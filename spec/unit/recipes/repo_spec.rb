# Test that the repo is being put on the box as desired

require 'spec_helper'

describe 'chef-bareos::repo' do
  ['6.7', '7.2.1511'].each do |version|
    context "on CentOS #{version}" do
      before do
        Fauxhai.mock(platform: 'centos', version: version)
      end

      let(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
        end.converge('chef-bareos::repo')
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it 'should add bareos yum repo' do
        # expect(chef_run).to add_yum_repository('bareos')
      end

      it 'should add bareos_contrib yum repo' do
        # expect(chef_run).to add_yum_repository('bareos_contrib')
      end
    end
  end

  ['12.04', '14.04'].each do |version|
    context "on Ubuntu #{version}" do
      before do
        Fauxhai.mock(platform: 'ubuntu', version: version)
      end

      let(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
        end.converge('chef-bareos::repo')
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it 'should add bareos apt repo' do
        # expect(chef_run).to add_apt_repository('bareos').with(
        #   'uri' => node['bareos']['baseurl'],
        #   'key' => node['bareos']['gpgkey'],
        #   'components' => ['/']
        # )
      end

      it 'should add bareos_contrib apt repo' do
        # expect(chef_run).to add_apt_repository('bareos_contrib').with(
        #   'uri' => node['bareos']['contrib_baseurl'],
        #   'key' => node['bareos']['contrib_gpgkey'],
        #   'components' => ['/']
        # )
      end
    end
  end
end
