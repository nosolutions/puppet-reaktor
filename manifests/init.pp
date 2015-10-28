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
# [*repo*]
#   URL of reaktor repository to clone
#   Default: 'https://github.com/pzim/reaktor.git',
class reaktor (
  $manage_user  = true,
  $user         = 'reaktor',
  $homedir      = '/home/reaktor',
  $uid          = 4500,
  $gid          = 4500,
  $repository   = 'https://github.com/pzim/reaktor.git',
  ) inherits ::reaktor::params {

  # validate parameters here
  validate_bool($manage_user)
  validate_string($user)
  validate_integer($uid)
  validate_integer($gid)
  validate_string($repository)

  class { '::reaktor::install': }
  # class { '::reaktor::config': } ~>
  # class { '::reaktor::service': } ->

  # Class['::reaktor']
}
