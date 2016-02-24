# Test that the repo is being put on the box as desired

require 'spec_helper'

describe 'chef-bareos::repo' do
  context 'Source is needed,' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end
    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
    it 'installing repo...'
  end

  context 'Packages required,' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end
    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
    it 'updating yum cache for main bareos packages...' do
      expect { chef_run }.to yum_repository(default['bareos']['yum_repository'])
    end
  end
end
