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

## General

Attribute        | Description |Type | Default
-----------------|-------------|-----|--------
['bareos']['url'] | Base URL for Bareos Repository | string | 'http://download.bareos.org/bareos/release'
['bareos']['version'] | Software Version | string | 'latest'

## Storage Daemon

Attribute        | Description |Type | Default
-----------------|-------------|-----|--------
['bareos']['clients'] | Monitor Clients | array | []
['bareos']['tape'] | Enable Tape Features | boolean | false
['bareos']['host_pools'] | Seperate Host Pools | boolean | false

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

You need to create a base role called ``bareos_base`` like this:

```
{
  "name": "bareos_base",
  "description": "Base Role for chef-bareos Cookbook, used in searches, throws down sources for installs",
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

### bareos_server role (install the bareos server for backups)

For the server, you need a role named ``bareos_server``, for example :

```
{
  "name": "bareos_server",
  "description": "Bareos Server Role",
  "json_class": "Chef::Role",
  "default_attributes": {
  },
  "override_attributes": {
  },
  "chef_type": "role",
  "run_list": [
    "role[bareos_base]",
    "recipe[bareos::database]",
    "recipe[bareos::server]",
    "recipe[bareos::storage]",
    "recipe[bareos::workstation]"
  ],
  "env_run_lists": {
  }
}
```

You need to run chef-client on the backup server every time you add a new node. All job will be automatically create for you.

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
