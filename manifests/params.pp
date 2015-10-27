# == Class reaktor::params
#
# This class is meant to be called from reaktor.
# It sets variables according to platform.
#
class reaktor::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'reaktor'
      $service_name = 'reaktor'
    }
    'RedHat', 'Amazon': {
      $package_name = 'reaktor'
      $service_name = 'reaktor'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
