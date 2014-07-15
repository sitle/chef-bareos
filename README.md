Bareos Cookbook
===============

This cookbook install and configurer backup based on bareos software (http://www.bareos.org/en/home.html)

Requirements
------------

#### packages
- `yum` - need yum packages to install bareos repos

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
    <td><tt>["bareos"]["yum_repository"]</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>["bareos"]["description"]</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>["bareos"]["baseurl"]</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>["bareos"]["gpgkey"]</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>["bareos"]["database_type"]</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>["bareos"]["dbdriver"]</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>["bareos"]["dbname"]</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>["bareos"]["dbuser"]</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>["bareos"]["dbpassword"]</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>["bareos"]["tape"]</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>["bareos"]["dir_password"]</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>["bareos"]["fd_password"]</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>["bareos"]["sd_password"]</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>


Usage
-----
#### bareos::default (install the bareos client backup by default)

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[bareos::default]"
  ]
}
```

#### bareos::server (install all in one server)

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[bareos::default]",
    "recipe[bareos::database]",
    "recipe[bareos::server]",
    "recipe[bareos::storage]",
    "recipe[bareos::workstation]"
  ]
}
```

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
