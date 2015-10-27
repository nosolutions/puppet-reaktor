# == Class reaktor::service
#
# This class is meant to be called from reaktor.
# It ensure the service is running.
#
class reaktor::service {

  service { $::reaktor::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
