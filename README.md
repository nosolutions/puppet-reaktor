#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with reaktor](#setup)
    * [What reaktor affects](#what-reaktor-affects)
    * [Setup requirements](#setup-requirements)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)

## Overview

Install and configure [reaktor](https://github.com/pzim/reaktor)

## Module Description

This module installs and configures reaktor (https://github.com/pzim/reaktor). It additonally creates upstart services (Ubuntu only) to run reaktor as a service.

## Setup

### What reaktor affects

* installs build-essential (Ubuntu only)
* installs reaktor using puppetlabs-ruby bundler

### Setup Requirements

* puppetlabs-stdlib (https://github.com/puppetlabs/puppetlabs-stdlib/)
* puppetlabs-ruby (https://github.com/puppetlabs/puppetlabs-ruby)
 * ruby::dev needs to be included.

## Usage

```puppet
class { 'reaktor':
  config => {
    REAKTOR_PUPPET_MASTERS_FILE => '/path/to/mastersfile.txt',
    PUPPETFILE_GIT_URL          => 'https://bath.to/puppetfile.git',
    ...
}
```

## Reference

### reaktor

Initialises and install reaktor.

#### reaktor::manage_user

Defines if the user which runs reaktor is created or not. Default: `true`.

#### reaktor::user

Defines the user which runs reaktor. Default `reaktor`.

#### reaktor::homedir

Defines the user's home directory which is also the directory where reaktor is installed to. Default: `/opt/reaktor`.

#### reaktor::shell

Defines the user's shell. Default: `/usr/sbin/nologin`.

#### reaktor::uid

Defines the user's UID. Default: `4500`.

#### reaktor::manage_group

Defines it the group is created or not. Default `true`.

#### reaktor::group

Defines the group. Default: `reaktor`.

#### reaktor::gid

Defines the group's GID. Default: `4500`.

#### reaktor::manage_service

Defines if the service(s) to run reaktor are created or not. Default: `true` on Ubuntu, `false` on all other systems.

#### reaktor::service_provider

A String defining the service provider. Default: `upstart` on Ubuntu, not set on all other systems.

#### reaktor::init_dir

A string defining the init direcotry. Default: `/etc/init` on Ubunutu, not set on all other systems.

#### reaktor::dir

A string defining the directory where reaktor is installed. Default `$reaktor::homedir`.

#### reaktor::repository

Defines the repository of the reaktor source code. Default: `https://github.com/pzim/reaktor.git`.

#### reaktor::build_essentials_package

Defines the package name for the build essentials. Default: `build-essential` for Ubuntu, `undef` for all other systems.

#### reaktor::config

A hash defining the configuration for reaktor. See the reaktor doc for more information (https://github.com/pzim/reaktor#environment-variables). In case the service runs as a (Ubuntu/upstart) service the environment variables are inserted into the service script.
Default: empty.

#### reaktor::address

Rake config defining the address. Default: `localhost`.

#### reaktor::port

Rake config defining the port. Default: `4570`.

#### reaktor::servers

Rake config defining the number of servers. Default: `1`.

#### reaktor::max_conns

Rake config defining the maximum number of connections. Default: `1024`.

#### reaktor::max_persistent_conns

Rake config defining the maximum number of persistent connections. Default: `512`.

#### reaktor::timeout

Rake config defining the timeout. Default: `30`.

#### reaktor::environment

Rake config defining the environment. Default: `production`.

#### reaktor::pid

Rake config defining the PID. Default: `tmp/pids/reaktor.pid`.

#### reaktor::log

Rake config defining the rake log output. Default: `reaktor.log`.

#### reaktor::daemonize

Rake config defining if reaktor runs as a daemon or not. Default: `false` on Ubuntu, `true` on all other systems.
Needs to be set to false on Ubuntu if reaktor should run as an (upstart) service.

## Limitations

Tested on Ubuntu 14.04

