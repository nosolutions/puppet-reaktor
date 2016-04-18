# == Class reaktor::redis
#
# This class manages the redis installation if manage_redis is set to true
#
class reaktor::redis {
  package { $::reaktor::redis_package:
    ensure   => present,
    provider => $::reaktor::redis_package_provider,
  }

  if $::osfamily == 'RedHat' {
    class { 'epel':
      epel_proxy => $::reaktor::proxy,
    }
    Class['epel'] -> Package[$reaktor::redis_package]
  }
}
