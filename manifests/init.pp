# == Class: reaktor
#
# Full description of class reaktor here.
#
# === Parameters
#
# [*manage_user*]
#   Should we create a user for running reaktor
#   Default: true
#
# [*user*]
#   Reaktor runs under this user
#   Default: 'reaktor'
#
# [*homedir*]
#   Defines the user's home directory which is also the directory where reaktor is installed to.
#   Default: `/opt/reaktor`
#
# [*shell*]
#   Defines the user's shell.
#   Default: `/usr/sbin/nologin`
#
# [*uid*]
#   Defines the user's UID.
#   Default: `4500`
#
# [*manage_group*]
#   Defines it the group is created or not.
#   Default `true`.
#
# [*group*]
#   Defines the group.
#   Default: `reaktor`.
#
# [*gid*]
#   Defines the group's GID.
#   Default: `4500`.
#
# [*manage_service*]
#   Defines if the service(s) to run reaktor are created or not.
#   Default: `true` on Ubuntu, `false` on all other systems.
#
# [*service_provider*]
#   A String defining the service provider.
#   Default: `upstart` on Ubuntu, not set on all other systems.
#
# [*init_dir*]
#   A string defining the init direcotry.
#   Default: `/etc/init` on Ubunutu, not set on all other systems.
#
# [*install_dir*]
#   A string defining the directory where reaktor is installed.
#   Default `${reaktor::homedir}/reaktor`.
#
# [*repository*]
#   Defines the repository of the reaktor source code.
#   Default: `https://github.com/pzim/reaktor.git`.
#
# [*build_essentials_package*]
#   Defines the package name for the build essentials.
#   Default: `build-essential` for Ubuntu, `undef` for all other systems.
#
# [*config*]
#   A hash defining the configuration for reaktor. See the reaktor doc for more information (https://github.com/pzim/reaktor#environment-variables). In case the service runs as a (Ubuntu/upstart) service the environment variables are inserted into the service script.
#   Default:
#     `{
#       'RACK_ROOT'                   => $reaktor::dir,
#       'RESQUE_WORKER_USER'          => $reaktor::user,
#       'RESQUE_WORKER_GROUP'         => $reaktor::group,
#       'REAKTOR_PUPPET_MASTERS_FILE' => "${reaktor::dir}/masters.txt",
#     }`
#
# [*address*]
#   Rake config defining the address.
#   Default: `${::fqdn}`.
#
# [*port*]
#   Rake config defining the port.
#   Default: `4570`.
#
# [*servers*]
#   Rake config defining the number of servers.
#   Default: `1`.
#
# [*max_conns*]
#   Rake config defining the maximum number of connections.
#   Default: `1024`.
#
# [*max_persistent_conns*]
#   Rake config defining the maximum number of persistent connections.
#   Default: `512`.
#
# [*timeout*]
#   Rake config defining the timeout.
#   Default: `30`.
#
# [*environment*]
#   Rake config defining the environment.
#   Default: `production`.
#
# [*pid*]
#   Rake config defining the PID.
#   Default: `tmp/pids/reaktor.pid`.
#
# [*log*]
#   Rake config defining the rake log output.
#   Default: `reaktor.log`.
#
# [*daemonize*]
#   Rake config defining if reaktor runs as a daemon or not.
#   Default: `false` on Ubuntu, `true` on all other systems.
#   Needs to be set to false on Ubuntu if reaktor should run as an (upstart) service.
#
# [*manage_masters*]
#   Used to define if the masters file should be create/managed by the puppet module.
#   Default: `true`.
#
# [*masters*]
#   Array containing the puppet masters.
#   Default: [].
#
# [*notifiers*]
#   Hash containing the configs for the notifiers which will be linked to the available notifiers.
#   Default: { hipchat.rb => { ensure => 'present'} }.
#
# [*manage_redis*]
#   Whether or not to manage the redis installation on this host.
#   Default: true  
#  
# [*redis_package*]
#   The name of the redis package to install
#   Default:
#     Redhat: redis
#     Debian: redis-server  
#
# [*redis_package_provider*]
#   The package provider to use for installing the redis package
#   Default:
#     Redhat: undef (so the default is used)
#     Debian: gem
#
# [*proxy*]
#   A proxy server used to install packages
#   Default: undef
#
class reaktor (
  $manage_user              = true,
  $manage_group             = true,
  $user                     = 'reaktor',
  $group                    = 'reaktor',
  $uid                      = 4500,
  $gid                      = 4500,
  $homedir                  = '/opt/reaktor',
  $shell                    = '/usr/bin/nologin',
  $manage_service           = $::reaktor::params::manage_service,
  $service_provider         = $::reaktor::params::service_provider,
  $init_dir                 = $::reaktor::params::init_dir,
  $install_dir              = undef,
  $repository               = 'https://github.com/pzim/reaktor.git',
  $build_essentials_package = $::reaktor::params::build_essentials_package,
  $config                   = {},
  $address                  = $::fqdn,
  $port                     = 4570,
  $servers                  = 1,
  $max_conns                = 1024,
  $max_persistent_conns     = 512,
  $timeout                  = 30,
  $environment              = 'production',
  $pidfile                  = 'tmp/pids/reaktor.pid',
  $log                      = 'reaktor.log',
  $daemonize                = $::reaktor::params::daemonize,
  $manage_masters           = true,
  $masters                  = [],
  $notifiers                = {},
  $manage_redis             = true,
  $redis_package            = $::reaktor::redis_package,
  $redis_package_provider   = $::reaktor::params::redis_package_provider,
  $proxy                    = undef,
  ) inherits ::reaktor::params {

  validate_bool($manage_user)
  validate_bool($manage_group)
  validate_string($user)
  validate_string($group)
  validate_integer($uid)
  validate_integer($gid)
  validate_absolute_path($homedir)
  validate_absolute_path($shell)
  validate_bool($manage_service)
  validate_string($repository)
  validate_hash($config)
  validate_string($address)
  validate_integer($port)
  validate_integer($servers)
  validate_integer($max_conns)
  validate_integer($max_persistent_conns)
  validate_integer($timeout)
  validate_string($environment)
  validate_string($pidfile)
  validate_string($log)
  validate_bool($daemonize)
  validate_bool($manage_masters)
  validate_array($masters)
  validate_hash($notifiers)
  validate_bool($manage_redis)
  validate_string($redis_package)
  validate_string($redis_provider)

  if $proxy != undef {
    validate_re($proxy,'^http://.*$', "Invalid variable proxy: ${proxy}, value must start with http://")
  }

  $_install_dir = $install_dir ? {
    undef   => "${homedir}/reaktor",
    default => $install_dir
  }
  validate_absolute_path($_install_dir)

  contain ::reaktor::install
  contain ::reaktor::config

  Class['::reaktor::install'] ->
  Class['::reaktor::config']

  if $manage_service {
    contain ::reaktor::service

    Class['::reaktor::config'] ~>
    Class['::reaktor::service']
  }
}
