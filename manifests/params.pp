# == Class reaktor::params
#
# This class is meant to be called from reaktor.
# It sets variables according to platform.
#
class reaktor::params {

  $ensure       = 'present'

  $manage_user  = true
  $user         = 'reaktor'
  $homedir      = '/opt/reaktor'
  $shell        = '/usr/sbin/nologin'
  $uid          = 4500

  $manage_group = true
  $group        = 'reaktor'
  $gid          = 4500

  $repository   = 'https://github.com/pzim/reaktor.git'

  # reaktor configs
  $address              = 'localhost'
  $port                 = 4570
  $servers              = 1
  $max_conns            = 1024
  $max_persistent_conns = 512
  $timeout              = 30
  $environment          = 'production'
  $pid                  = 'tmp/pids/reaktor.pid'
  $log                  = 'reaktor.log'

  # masters.txt file
  $manage_masters = true

  case $::osfamily {
    'Debian': {
      $manage_service           = true
      $service_name             = 'reaktor'
      $service_provider         = 'upstart'
      $build_essentials_package = 'build-essential'
      $init_dir                 = '/etc/init'
      $daemonize                = false
    }
    'RedHat', 'Amazon': {
      $manage_service           = false
      $service_name             = 'reaktor'
      $build_essentials_package = undef
      $daemonize                = true
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
