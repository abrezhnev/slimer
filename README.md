RHEL-OSP5 HA deployment with Ansible
====================================

These scripts were used for deployment of RHEL-OSP5 in HA mode with Ceph storage backend for Cinder and Glance.

The infrastructure for OpenStack is based on MariaDB-Galera and RabbitMQ in active/active mode.

Network stack is implemented with Nova Network.

Ansible configuration defines how to access all OpenStack nodes from the installation workstation. The hosts file need to be customized for the environment.

The OpenStack configuration is defined in the group specific configuration files: group_vars/*

