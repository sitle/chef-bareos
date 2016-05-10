Chef-Bareos Cookbook
====================

[![BuildStatus](https://travis-ci.org/sitle/chef-bareos.svg?branch=master)](https://travis-ci.org/sitle/chef-bareos)
[![Join the chat at https://gitter.im/EMSL-MSC/chef-bareos](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/EMSL-MSC/chef-bareos?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)  

This cookbook installs and configures backups based on [BAREOS](https://www.bareos.org/en/).

[Official BAREOS Documentation](http://doc.bareos.org/master/html/bareos-manual-main-reference.html).

# Requirements

## Supported Platforms:

 * Ubuntu 14.04 (plan to add 16.04 as soon as binary is released)
 * Debian 7 (8+ may or may not work, you'll need a repo basically)
 * CentOS 6+
 * RHEL 6+ (Assumed to work just as well as on CentOS)

## Supported Chef Versions:

 * Chef 11+

# Attributes

## Repository
Assists with adding necessary sources for installing Bareos

Attribute        | Description | Type | Default
-----------------|-------------|------|---------

## Messages
Defines default admin e-mail address for service notifications and what messages to care about

Attribute        | Description | Type | Default
-----------------|-------------|------|---------

## Database
Prefills the Catalog resource in the main Director configuration

Attribute        | Description | Type | Default
-----------------|-------------|------|---------

## Clients
Provides resources for the Catalog (Director configuration) and Filedaemon configurations/templates

Attribute        | Description | Type | Default
-----------------|-------------|------|---------

## Storage Daemon
Provides for a baseline Storage Daemon Config with optional configurables

Attribute        | Description | Type | Default
-----------------|-------------|------|---------

## Director
Provides standard variables for a typical Director configuration

Attribute        | Description | Type | Default
-----------------|-------------|------|---------

## Subscription Management (Director)
Provides a system counter method if you have a paid service subscription

Attribute        | Description | Type | Default
-----------------|-------------|------|---------

## Workstation
Determines if you want to use FQDN or some other way of defining hosts in your management workstation deployment

Attribute        | Description | Type | Default
-----------------|-------------|------|---------

# Basic Usage

## Roles

### Basic bareos\_client role
Install the Bareos Client so hosts can be backup automatically (required)

You'll need a searchable client role named ```bareos_client```, for example:
```

{
  "name": "bareos_client",
  "description": "Example Role for Bareos clients using the chef-bareos Cookbook, used in searches, throws down sources for installs",
  "json_class": "Chef::Role",
  "default_attributes": {
  },
  "override_attributes": {
  },
  "chef_type": "role",
  "run_list": [
    "recipe[chef-bareos]"
  ],
  "env_run_lists": {
  }
}
```

This role has to be applied to all your clients so they can be backed up by this cookbook.

### Basic bareos\_director role
Install the Bareos Director for scheduling backups (required).

You'll need a searchable director role named ```bareos_director```, for example:
```

{
  "name": "bareos_director",
  "description": "Example Role for a Bareos director",
  "json_class": "Chef::Role",
  "default_attributes": {
  },
  "override_attributes": {
  },
  "chef_type": "role",
  "run_list": [
    "role[bareos_client]",
    "recipe[chef-bareos::database]",
    "recipe[chef-bareos::server]",
    "recipe[chef-bareos::workstation]"
  ],
  "env_run_lists": {
  }
}

```

You'll need to run chef-client on the backup server every time you add a new node. Client jobs should be created for you automatically.

Running the server recipe should work in chef-solo but you need to populate the ['bareos']['clients'] attribute with an array of client names.

### Basic bareos\_storage role
Install the Bareos Storage Daemon for data transfers (required).

You'll need a searchable storage role named ```bareos_storage```, for example:
```

{
  "name": "bareos_storage",
  "description": "Example Role for a Bareos storage",
  "json_class": "Chef::Role",
  "default_attributes": {
  },
  "override_attributes": {
  },
  "chef_type": "role",
  "run_list": [
    "recipe[chef-bareos::storage]"
  ],
  "env_run_lists": {
  }
}

```

## Recipes and Hashable Configurations

### Recipes
#### default.rb
Installs necessary repos and includes the Bareos client recipe
#### client.rb
Installs client packages and creates a config file that is linked to available directors on chef server.
You may also feed directors to the config via attributes if running in solo mode.
#### repo.rb
Installs base Bareos repo as well as the Bareos Contrib repo.
#### database.rb
Installs whichever database is desired per attributes (PostgreSQL/MySQL), installs Bareos database packages and creates the bareos database and user for you. Should also set the database password by default. You may need to recover this from the attributes or set a new one via vault via wrapper recipe.
#### server.rb
Installs necessary Bareos server packages and sets up base configs necessary for server to start. Also creates the config directory (bareos-dir.d) so you can drop whatever outside config files into place and have them get automatically included in your setup.
#### storage.rb
Installs necessary Bareos storage packages and sets up a default file storage for you to start backing stuff up to right away (configured for ~250GB of volumes by default).
#### autochanger.rb
This bit will setup an autochanger based on a pretty straight forward has table. Tested with IBM TS3500 Tape Library with 10 Frames and 16 Tape drives.
#### workstation.rb
Installs bconsole essentially. I plan to create another recipe for bat (Bareos Administration Tool) and the Bareos Web UI but I haven't gotten around to it yet.
#### graphite_plugin.rb
This was an exciting recent addition to the Bareos contrib GitHub repo. This addition in its current form will be dependent on a pending merge request getting accepted but if it isn't merged it can be easily worked around. Should work out of the gate here pretty soon given you adjust the graphite server string in the attributes for a graphite server location.
### Hashable Configurations for templates
#### bconsole
#### clients
#### autochanger
#### dir\_helper
#### filesets
#### job\_definitions (jobdefs)
#### jobs
#### pools
#### schedules
#### sd\_helper
#### storages

# Contributing

1. Fork the repository on Github
2. Create a named feature branch (like ```add_component_x```)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

## License and Authors

### License

Copyright 2014 Léonard TAVAE

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

### Authors

* Léonard TAVAE
* Ian Smith
* Gerhard Sulzberger
