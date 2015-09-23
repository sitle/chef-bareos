Chef-Bareos Cookbook
====================

[![Build Status](https://travis-ci.org/sitle/chef-bareos.svg?branch=master)](https://travis-ci.org/sitle/chef-bareos)

This cookbook installs and configures backups based on [Bareos](https://www.bareos.org/en/).

# Requirements

This cookbook has been tested with RHEL, Debian, Ubuntu systems. It should work with Chef 11 and Chef 12 configurations, if not please file a bug report and it will be addressed. The chef-bareos cookbook is still undergoing some feature additions so it is recommended to watch for changes to the README.

# Attributes

## Repository

Attribute        | Description | Type | Default
-----------------|-------------|------|---------
['bareos']['url'] | Base URL for Bareos Repository | string | 'http://download.bareos.org/bareos/release'
['bareos']['version'] | Software Version | string | '14.2'

OS Family     | Attribute | Default
--------------|-----------|---------
rhel/fedora |['bareos']['yum_repository'] | 'bareos'
rhel/fedora |['bareos']['description'] | 'Description of repo string'
varies | ['bareos']['baseurl'] | See attributes file
varies | ['bareos']['gpgkey'] | See attributes file

## Database

Attribute        | Description | Type | Default
-----------------|-------------|------|---------
['bareos']['database']['catalog_name'] | Catalog Name | string | 'MyCatalog'
['bareos']['database']['database_type'] | Database type | string | 'postgresql'
['bareos']['database']['dbdriver'] | Database driver | string | 'postgresql'
['bareos']['database']['dbname'] | Database default name | string | 'bareos'
['bareos']['database']['dbuser'] | Database user name | string | 'bareos'
['bareos']['database']['dbpassword'] | Database password | string | ''
['bareos']['database']['dbaddress'] | Database address | string | nil 

## Clients

Attribute        | Description | Type | Default
-----------------|-------------|------|---------
['bareos']['clients']['fd_port'] | | | 9102
['bareos']['clients']['max_concurrent_jobs'] | | | 20
['bareos']['clients']['client_list'] | | | {}
['bareos']['clients']['file_retention'] | | | '30 days'
['bareos']['clients']['job_retention'] | | | '6 months'
['bareos']['clients']['autoprune'] | | | 'no'
['bareos']['clients']['heartbeat_interval'] | | | 600
['bareos']['clients']['jobdef_default_runlevel'] | | | 10
['bareos']['clients']['jobdef_default_storage'] | | | 'File'
['bareos']['clients']['jobdef_default_messages'] | | | 'Standard'
['bareos']['clients']['jobdef_default_fileset'] | | | 'Full Set'
['bareos']['clients']['jobdef_default_schedule'] | | | 'WeeklyCycle'
['bareos']['clients']['host_pools'] | | | '0'
['bareos']['clients']['default_pool'] | | | 'Default'
['bareos']['clients']['full_pool'] | | | 'Full-Pool'
['bareos']['clients']['incremental_pool'] | | | 'Inc-Pool'
['bareos']['clients']['differential_pool'] | | | 'Diff-Pool'
['bareos']['clients']['enable_vfulls'] | | | false

## Storage Daemon
Attribute        | Description | Type | Default
-----------------|-------------|------|---------

['bareos']['storage']['sd_port'] | | | 9103
['bareos']['storage']['tape'] | | | false
['bareos']['storage']['servers'] | | | {}
['bareos']['storage']['custom_configs'] | | | '0'
['bareos']['storage']['sd_mon_enable'] | | | 'yes'
['bareos']['storage']['max_concurrent_jobs'] | | | 20

## Director
Attribute        | Description | Type | Default
-----------------|-------------|------|---------
['bareos']['director']['dir_port'] | | | 9101
['bareos']['director']['dir_max_concurrent_jobs'] | | | 20
['bareos']['director']['custom_configs'] | | | '1'
['bareos']['director']['servers'] | | | {}

## Subscription Management (Director)

Attribute        | Description | Type | Default
-----------------|-------------|------|---------
['bareos']['dir_subscription'] | Support Subscription Status | boolean | nil/False
['bareos']['dir_subs'] | Subscription Level/Count | number | nil

## Messages
Attribute        | Description | Type | Default
-----------------|-------------|------|---------
['bareos']['messages']['mail_to'] | | | "bareos@#{node['domain_name']}"
['bareos']['messages']['default_messages'] | | | 'Standard'

## Workstation
Attribute        | Description | Type | Default
-----------------|-------------|------|---------
['bareos']['workstation']['solo_mode'] | | | '0'

# Basic Usage

## Roles

### bareos_client role (install the bareos client backup by default)

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
    "recipe[chef-bareos]"
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
    "role[bareos_client]",
    "recipe[chef-bareos::server]",
    "recipe[chef-bareos::database]",
    "recipe[chef-bareos::storage]",
    "recipe[chef-bareos::workstation]"
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
