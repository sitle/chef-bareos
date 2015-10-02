#
# Cookbook Name:: chef-bareos
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'chef-bareos::default' do

  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('chef-bareos::client')
  end

  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'includes the client recipe' do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('chef-bareos::client')
      chef_run
    end

    # it 'includes the openssl recipe' do
    #   expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('openssl::default')
    #   chef_run
    # end

  end

  context 'on an ubuntu 12.04 box' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '12.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'adds the apt repo' do
      expect(chef_run).to add_apt_repository('bareos')
    end
  end

  context 'on an centos 6.6 box' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.6') do |node|
        node.set['bareos']['yum_repository'] = 'bareos-repo-test'
        node.set['bareos']['baseurl'] = "http://foo/bar"
      end
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'adds the yum repo' do
      expect(chef_run).to create_yum_repository('bareos-repo-test').with( baseurl: "http://foo/bar"  )
    end
  end

end