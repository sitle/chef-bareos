Chef-Bareos Cookbook
====================

[![Build Status](https://travis-ci.org/sitle/chef-bareos.svg?branch=master)](https://travis-ci.org/sitle/chef-bareos)

This cookbook installs and configures backups based on [Bareos](https://www.bareos.org/en/).

# Requirements

This cookbook has been tested with RHEL, Debian, Ubuntu systems. It should work with Chef 11 and Chef 12 configurations, if not please file a bug report and it will be addressed. The chef-bareos cookbook is still undergoing some feature additions so it is recommended to watch for changes to the README.

# Attributes

## Database

Attribute        | Description |Type | Default
-----------------|-------------|-----|--------
["bareos"]["database_type"] | Specify the database type | string | 'postgresql'
["bareos"]["dbdriver"] | Specify the database driver | string | 'postgresql'
["bareos"]["dbname"] | Specify the database default name | string | 'bareos'
["bareos"]["dbuser"] | Specify the db user name | string | 'bareos'
["bareos"]["dbpassword"] | Specify the db password | string | ''
["bareos"]["dbaddress"] | Specify the db address | string | nil 

## General

Attribute        | Description |Type | Default
-----------------|-------------|-----|--------
['bareos']['url'] | Base URL for Bareos Repository | string | 'http://download.bareos.org/bareos/release'
['bareos']['version'] | Software Version | string | '14.2'

## Storage Daemon
Attribute        | Description |Type | Default
-----------------|-------------|-----|--------
['bareos']['tape'] | Enable Tape Features | boolean | false
['bareos']['storage']['server'] | Define name of SD server | string | node['hostname']
['bareos']['storage']['custom_configs'] | Allows custom SD configs via wrapper | string | '0'

## Clients/Hosts

Attribute        | Description |Type | Default
-----------------|-------------|-----|--------
['bareos']['clients'] | Monitor Clients (Solo Mode only right now) | array | %w()
['bareos']['host_pools'] | Seperate Host Pools | string | '0'
['bareos']['default_pool'] |  Basic Default Pool | string | 'Default'
['bareos']['full_pool'] | Basic Full Pool | string | 'Full-Pool'
['bareos']['incremental_pool'] | Basic Incremental Pool | string | 'Inc-Pool'
['bareos']['differential_pool'] | Basic Differential Pool | string | 'Diff-Pool'
['bareos']['enable_vfulls'] | Activate basic Virtual Full Backups (Not currently used, on radar though) | boolean | false

## Director

Attribute        | Description |Type | Default
-----------------|-------------|-----|--------
['bareos']['dir_port'] | Network Port for Director | number | 9101
['bareos']['dir_max_concurrent_jobs'] | Max concurrent jobs for director | number | 20

## Subscription Management (Director)

Attribute        | Description |Type | Default
-----------------|-------------|-----|--------
['bareos']['dir_subscription'] | Support Subscription Status | boolean | nil/False
['bareos']['dir_subs'] | Subscription Level/Count | number | nil

# Basic Usage

## Roles

### bareos_base role (install the bareos client backup by default)

You need to create a client role called ``bareos_client`` like this:

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
    "recipe[bareos]"
  ],
  "env_run_lists": {
  }
}
```
This role has to be applied to all your clients so they can be backed up by this cookbook.

### bareos_server role (install the bareos server for scheduling backups)

For the primary server, if not splitting out services, you need a role named ``bareos_server``, for example :

```
{
  "name": "bareos_server",
  "description": "Example Role for a Bareos server",
  "json_class": "Chef::Role",
  "default_attributes": {
  },
  "override_attributes": {
  },
  "chef_type": "role",
  "run_list": [
    "role[bareos_base]",
    "recipe[bareos::server]",
    "recipe[bareos::database]",
    "recipe[bareos::storage]",
    "recipe[bareos::workstation]"
  ],
  "env_run_lists": {
  }
}
```

You'll need to run chef-client on the backup server every time you add a new node. Client jobs should be created for you automatically.

Running the server recipe should work in chef-solo but you need to populate the ['bareos']['clients'] attribute with an array of clients.


# Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

## License and Authors

### License 

```
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
```

### Authors 

* Léonard TAVAE
* Ian Smith
* Gerhard Sulzberger
