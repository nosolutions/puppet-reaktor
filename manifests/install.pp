# == Class reaktor::install
#
# This class is called from reaktor for install.
#
class reaktor::install {

  package { $::reaktor::package_name:
    ensure => present,
  }
}
