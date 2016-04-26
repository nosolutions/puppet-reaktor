# == Class reaktor::service
#
# This class is meant to be called from reaktor.
# It ensure the service is running.
#
class reaktor::service {
  case $::osfamily {
    'Debian': {
      contain ::reaktor::service::debian
    }
    'RedHat': {
      contain ::reaktor::service::redhat
    }
    default: {
      warn("Service management is not implemented for ${::osfamily}")
    }
  }
}
