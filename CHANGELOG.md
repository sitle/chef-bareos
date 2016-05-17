CHANGELOG
=========
Chef-Bareos Cookbook
--------------------

3.0.3
-----
#### Ian Smith
  * Decided to change who owned all of the graphite_plugin bits
    1. Bareos plugin still seems to have some debugging code that will not only PRINT your password to the command line if done by hand, but will also EMAIL your main director password to whatever account owns, say, a cronjob (i.e. root). Seems like a security flaw? I submitted bugfix bareos/bareos-contrib/#14 to address this issue, waiting for merge. If you need an immediate fixed source, use my GitBytes/bareos-contrib fork. Sorry about that..
    1. Pretty much wherever root was, I changed to bareos in the plugin recipe.
  * Cleanup README and CHANGELOG raw syntax for GitHub and Supermarket rendering
  * Add new chefspec/rspec unit tests, cleanup existing tests
    1. Removed unused `.rspec` config file
    1. Removed `repo_spec` test, never quite worked right
    1. Added `:documentation` and `color` output to chefspec/rspec testing
    1. Added `graphite_plugin_spec` test
    1. Condensed and cleaned up `default_spec` test, tests both the `repo` and `client` recipes on top of the implied `default` recipe
    1. Added ability to easily run tests against a variety of preset supported platforms via `spec/unit/support/supported_platforms` definition file (see `default_spec` test for example usage)
  * Add new/optimize serverspec integration tests
    1. Condense tests for overall functionality of Bareos
    1. New graphite plugin testing: plugin, config, cronjob
  * Bump patch version to `3.0.3` (tag v3.0.3)

3.0.2
-----
#### Ian Smith
  * Complete re-work of cookbook, which includes the rework bits from version 2.0
  * Adding various features including:
    * Templates populated from hash tables
    * Up to date README
    * Graphite plugin deployment recipe
    * Migrate to postgresql cookbook version 4+
    * Better testing (rspec), testing against current ruby, need some more rspec tests but no time
    * Various other updates and enhancements, see README for details
    * Supermarket Release...finally
  * ***NOTE*** This release adds functionality that is not backwards compatible. Version lock until you have time to test the migration to version 3.0+

2.2.13
------
#### Ian Smith
  * Near complete refactoring of how the cookbook works
    * Adding various ways to add configs based on hashes. Examples in attributes/default.rb
  * Updating README for usage details
  * If you are not prepared to use this cookbook version, please lock cookbook version to < 2.0.0
  * TODO: Refactor main bareos-dir/sd/fd configs to be fully based on hashes like other configs
    * Remaining attributes support primary bareos-dir/sd/fd configs mostly, used elsewhere but not much

1.0.4
-----
#### Ian Smith
  * Updating and validating Kitchen testing with new methods
  * Adding ability to use custom Storage Daemon Configs via wrapper recipe
  * Fixed a race condition that was likely to come up both in testing and production
    * Was missing client config on fresh install so restart of dir would fail
  * Limiting cookbook support for debian to ~>7.0 until we can test on 8+
  * Refined storage recipe to correctly create client configs based on BOTH role search and solo instances, may need a bit more tuning but should work in most cases
  * Creating basic Full, Inc, and Diff pools even if not used, just as a place holder (default)
  * Minor fixes
  * Larger version bump for version clarity
  * Updated Docs
  * Adding support for Fedora and RHEL 6/7
  * Reworked the available repos to some better logic

0.1.4
-----
#### Ian Smith
  * Updating README
  * Revamping server.rb recipe to better utilize the bareos-dir.d directory
    * Moving ALL host config files to the bareos-dir.d/hosts/ directory
    * Revamping director config and moving host bits to separate host.conf.erb template
    * Adding feature for host based custom pools based on true/false attribute
    * Adding ability to fill in a block for virtual-full backup logic (not complete yet)
  * Revamping storage.rb and storage template to what I am thinking was meant to happen originally
  * Adding new kitchen suite and tests to verify host pools work
  * Bugfixes
  * Updating Kitchen Tests and ChefSpec Configs to match for verifying
    * Addressing race condition in ChefSpec tests where debian was taking
      longer than expected to start the director

0.1.3
-----
#### Ian Smith
  * Updating README
  * Updating CHANGELOG
  * Updating metadata file

0.1.2
-----
#### Leonard TAVAE
  * The License has changed (Apache 2.0)
  * The cookbook now passed foodcritic, rubocop and tailor with success
  * Some minor bugs fix

#### Ian Smith
  * Updating Cookbook to use ChefDK >0.6.0
  * Updating Docs
  * Updating Postgresql Logic/Commands
  * Updating a couple of template bits for the director
    * Adding new attributes, working on more for future implementation
  * Updating Kitchen suites/platforms/provisioner
    * Adding some test roles for tests
  * Updating chefspec/rspec/serverspec testing
  * Updating TravisCI testing parameters so they are more standard

0.1.1
-----
#### Leonard TAVAE
  * Major release

0.1.0
-----
#### Leonard TAVAE
  * Initial release of bareos
- - -
