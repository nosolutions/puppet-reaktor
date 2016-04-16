# == Class reaktor::params
#
# This class is meant to be called from reaktor.
# It sets variables according to platform.
#
class reaktor::params {
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
      $service_provider         = undef
      $build_essentials_package = undef
      $init_dir                 = undef
      $daemonize                = true
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
