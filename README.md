Bareos Cookbook
===============

This cookbook install and configure backup based on bareos software (http://www.bareos.org/en/home.html)

Requirements
------------

#### packages
- `yum` - need yum packages to install bareos repos on rhel platform
  family
- `apt` - need apt packages to install bareos repos on Debian platform
  family
- `openssl` - need openssl packages to install bareos repos

Attributes
----------

#### bareos::default
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


Usage
-----
#### bareos::default (install the bareos client backup by default)

You need to create a role "base" like this :

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
This "role base" has to be apply to all your nodes.

#### role backup-server

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

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: 

* Léonard TAVAE
