# Bareos Cookbook

[![Build Status](https://travis-ci.org/sitle/chef-bareos.svg?branch=master)](https://travis-ci.org/sitle/chef-bareos)

This cookbook install and configure backup based on [bareos software](http://www.bareos.org/en/home.html)

### Requirements

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>["bareos"]["database_type"]</tt></td>
    <td>string</td>
    <td>Specify the database type.</td>
    <td><tt>postgresql</tt></td>
  </tr>
  <tr>
    <td><tt>["bareos"]["dbdriver"]</tt></td>
    <td>string</td>
    <td>Specify the database driver.</td>
    <td><tt>postgresql</tt></td>
  </tr>
  <tr>
    <td><tt>["bareos"]["dbname"]</tt></td>
    <td>string</td>
    <td>Specify the database default name.</td>
    <td><tt>bareos</tt></td>
  </tr>
  <tr>
    <td><tt>["bareos"]["dbuser"]</tt></td>
    <td>string</td>
    <td>Specify the db user name.</td>
    <td><tt>bareos</tt></td>
  </tr>
  <tr>
    <td><tt>["bareos"]["dbpassword"]</tt></td>
    <td>string</td>
    <td>Specify the db password.</td>
    <td><tt>none</tt></td>
  </tr>
</table>

## Usage

### Base role (install the bareos client backup by default)

You need to create a base role like this :

```
{
  "name": "base",
  "description": "",
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
This role have to be applied to all your node so they can be backed up by this cookbook.

### backup-server role (install the bareos server backup)

For the server you need a role named ```backup-server``` with for example :

```
{
  "name": "backup-server",
  "description": "Backup server role",
  "json_class": "Chef::Role",
  "default_attributes": {
  },
  "override_attributes": {
  },
  "chef_type": "role",
  "run_list": [
    "role[base]",
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

## Contributing

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
