## Rainloop Webmail Client Installation Role for CentOS 7

This role installs and configures the Rainloop webmail client on CentOS 7.

## Requirements

None.

## Role Variables

`RAINLOOP_VERSION` - current version is `1.12.1`

`RAINLOOP_WEB_ROOT` - directory where Rainloop should be installed

## Dependencies

Rainloop requires PHP and MySQL.

These roles will satisfy this requirement:

mariuszczyz.centos-php

mariuszczyz.centos-mysql

## Example Playbook

Fetch this role from Ansible Galaxy:

`ansible-galaxy install mariuszczyz.centos-rainloop`

In playbook.yml:

```yaml
- hosts: rainloop
  roles:
    - { role: mariuszczyz.centos-rainloop, tags: ['rainloop'] }
```

Run it:

`ansible-playbook -i hosts playbook.yml --user root --ask-pass --limit=rainloop`

## License

BSD

## Author Information

Author: Mariusz Czyz
Date: 10/2018
