# Test that the repo is being put on the box as desired

require 'spec_helper'

describe 'chef-bareos::repo' do


  ['6.7', '7.2.1511'].each do |version|
    context "on CentOS #{version}" do
      before do
        Fauxhai.mock(platform: 'CentOS', version: version)
      end

      let(:chef_run) do
        runner = ChefSpec::ServerRunner.new
        runner.converge('chef-bareos::repo')
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it 'should install bareos repo'
      it 'should install bareos contrib repo'
    end
  end

  ['12.04', '14.04'].each do |version|
    context "on Ubuntu #{version}" do
      before do
        Fauxhai.mock(platform: 'ubuntu', version: version)
      end

      let(:chef_run) do
        runner = ChefSpec::ServerRunner.new
        runner.converge('chef-bareos::repo')
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it 'should install bareos repo'
      it 'should install bareos contrib repo'
    end
  end
end
