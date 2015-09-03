Bareos Cookbook CHANGELOG
==========================

This file is used to list changes made in each version of the bareos cookbook.

0.1.4
-----
- Ian smith

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
- Ian smith

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
