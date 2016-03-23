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
# [*dir*]
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
#   Default: `localhost`.
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

class reaktor (
  $manage_user              = $::reaktor::params::manage_user,
  $user                     = $::reaktor::params::user,
  $homedir                  = $::reaktor::params::homedir,
  $shell                    = $::reaktor::params::shell,
  $uid                      = $::reaktor::params::uid,

  $manage_group             = $::reaktor::params::manage_group,
  $group                    = $::reaktor::params::group,
  $gid                      = $::reaktor::params::gid,

  $manage_service           = $::reaktor::params::manage_service,
  $service_provider         = $::reaktor::params::service_provider,
  $init_dir                 = $::reaktor::params::init_dir,

  $dir                      = undef,
  $repository               = $::reaktor::params::repository,
  $build_essentials_package = $::reaktor::params::build_essentials_package,
  $config                   = {},
  
  $address              = $::reaktor::params::address,
  $port                 = $::reaktor::params::port,
  $servers              = $::reaktor::params::servers,
  $max_conns            = $::reaktor::params::max_conns,
  $max_persistent_conns = $::reaktor::params::max_persistent_conns,
  $timeout              = $::reaktor::params::timeout,
  $environment          = $::reaktor::params::environment,
  $pid                  = $::reaktor::params::pid,
  $log                  = $::reaktor::params::log,
  $daemonize            = $::reaktor::params::daemonize,

  $manage_masters = $::reaktor::params::manage_masters,
  $masters        = []
  ) inherits ::reaktor::params {

  # validate parameters here
  validate_bool($manage_user)
  validate_string($user)
  validate_absolute_path($homedir)
  validate_absolute_path($shell)
  validate_integer($uid)

  validate_bool($manage_group)
  validate_string($group)
  validate_integer($gid)

  validate_string($repository)

  $_dir = $dir ? {
    undef   => "${homedir}/reaktor",
    default => $dir
  }
  validate_absolute_path($_dir)

  class { '::reaktor::install': }

  if $manage_service {
    class { '::reaktor::service': }
  }
  class { '::reaktor::config': }
}
