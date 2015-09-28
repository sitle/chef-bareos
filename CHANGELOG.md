Bareos Cookbook CHANGELOG
==========================

This file is used to list changes made in each version of the bareos cookbook.

1.0.3
-----
- Ian Smith

  - Updating and validating Kitchen testing with new methods
  - Adding ability to use custom Storage Daemon Configs via wrapper recipe
  - Fixed a race condition that was likely to come up both in testing and production
    * Was missing client config on fresh install so restart of dir would fail
  - Limiting cookbook support for debian to ~>7.0 until we can test on 8+
  - Refined storage recipe to correctly create client configs based on BOTH role search and solo instances, may need a bit more tuning but should work in most cases
  - Creating basic Full, Inc, and Diff pools even if not used, just as a place holder (default)
  - Minor fixes
  - Larger version bump for version clarity
  - Updated Docs
  - Adding support for Fedora and RHEL 6/7
  - Reworked the available repos to some better logic

0.1.4
-----
- Ian Smith

  - Updating README
  - Revamping server.rb recipe to better utilize the bareos-dir.d directory
    * Moving ALL host config files to the bareos-dir.d/hosts/ directory
    * Revamping director config and moving host bits to seperate host.conf.erb template
    * Adding feature for host based custom pools based on true/false attribute
    * Adding ability to fill in a block for virtual-full backup logic (not complete yet)
  - Revamping storage.rb and storage template to what I am thinking was meant to happen originally
  - Adding new kitchen suite and tests to verify host pools work
  - Bugfixes
  - Updating Kitchen Tests and ChefSpec Configs to match for verifying
    * Addressing race condition in ChefSpec tests where debian was taking
      longer than expected to start the director

0.1.3
-----
- Ian Smith

  - Updating README
  - Updating CHANGELOG
  - Updating metadata file

0.1.2
-----
- Léonard TAVAE

  - The License has changed (Apache 2.0)
  - The cookbook now passed foodcritic, rubocop and tailor with success
  - Some minor bugs fix

- Ian Smith

  - Updating Cookbook to use ChefDK >0.6.0
  - Updating Docs
  - Updating Postgresql Logic/Commands
  - Updating a couple of template bits for the director
    * Adding new attributes, working on more for future implementation
  - Updating Kitchen suites/platforms/provisioner
    * Adding some test roles for tests
  - Updating chefspec/rspec/serverspec testing
  - Updating TravisCI testing parameters so they are more standard

0.1.1
-----
- Léonard TAVAE - Major release

0.1.0
-----
- Léonard TAVAE - Initial release of bareos

- - -
