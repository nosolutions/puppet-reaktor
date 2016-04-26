# == Class reaktor::params
#
# This class is meant to be called from reaktor.
# It sets variables according to platform.
#
class reaktor::params {
  case $::osfamily {
    'Debian': {
      $service_name             = 'reaktor'
      $service_provider         = 'upstart'
      $build_essentials_package = 'build-essential'
      $init_dir                 = '/etc/init'
      $daemonize                = false
      $redis_package            = 'redis-server'
      $redis_package_provider   = 'gem'
      $redis_service_name       = 'redis-server'
      $pidfile                  = 'tmp/pids/reaktor.pid'
    }
    'RedHat': {
      $service_name             = 'reaktor'
      $service_provider         = undef
      $build_essentials_package = undef
      $init_dir                 = undef
      $daemonize                = true
      $redis_package            = 'redis'
      $redis_package_provider   = undef
      $redis_service_name       = 'redis'
      $pidfile                  = '/run/reaktor/reaktor.pid'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
