Chef-Bareos Cookbook
====================

[![Build Status](https://travis-ci.org/sitle/chef-bareos.svg?branch=master)](https://travis-ci.org/sitle/chef-bareos)

This cookbook installs and configures backups based on [BAREOS](https://www.bareos.org/en/).

[Official BAREOS Documentation](http://doc.bareos.org/master/html/bareos-manual-main-reference.html).

# Requirements

## Supported Platforms:

 * Ubuntu 12.04+
 * Debian 7
 * CentOS 6+
 * RHEL 6+
 * Fedora 21/22

## Supported Chef Versions:

 * Chef 11+

# Attributes

## Repository

Attribute        | Description | Type | Default
-----------------|-------------|------|---------

## Messages

Attribute        | Description | Type | Default
-----------------|-------------|------|---------

## Database

Attribute        | Description | Type | Default
-----------------|-------------|------|---------

## Clients

Attribute        | Description | Type | Default
-----------------|-------------|------|---------

## Storage Daemon

Attribute        | Description | Type | Default
-----------------|-------------|------|---------

## Director

Attribute        | Description | Type | Default
-----------------|-------------|------|---------

## Subscription Management (Director)

Attribute        | Description | Type | Default
-----------------|-------------|------|---------

## Workstation

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

## Recipes (More detail coming)

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
