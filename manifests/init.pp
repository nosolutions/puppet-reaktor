# == Class: reaktor
#
# Full description of class reaktor here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class reaktor (
  $package_name = $::reaktor::params::package_name,
  $service_name = $::reaktor::params::service_name,
) inherits ::reaktor::params {

  # validate parameters here

  class { '::reaktor::install': } ->
  class { '::reaktor::config': } ~>
  class { '::reaktor::service': } ->
  Class['::reaktor']
}
