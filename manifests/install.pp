# == Class reaktor::install
#
# This class is called from reaktor for install.
#
class reaktor::install {
  vcsrepo { $::reaktor::_install_dir:
    ensure   => present,
    provider => 'git',
    force    => true,
    source   => $::reaktor::repository,
    user     => $::reaktor::user,
    notify   => Ruby::Bundle[$::reaktor::_install_dir],
  }

  file {
    ["${::reaktor::homedir}/log",
     "${::reaktor::homedir}/etc"]:
       ensure => directory,
       owner  => $::reaktor::user,
       group  => $::reaktor::group,
       mode   => '0755',
       require => Vcsrepo[$reaktor::_install_dir],
  }

  unless $::reaktor::build_essentials_package == undef {
    ensure_packages($::reaktor::build_essentials_package)
    Package[$::reaktor::build_essentials_package] {
      before => Ruby::Bundle[$::reaktor::_install_dir]
    }
  }

  if $::reaktor::manage_redis == true {
    contain reaktor::redis
  }

  include ruby
  include ruby::dev
  
  # need to be installed as root
  ruby::bundle { $::reaktor::_install_dir:
    cwd         => $::reaktor::_install_dir,
    option      => '--without development test doc',
    user        => 0,
    group       => 0,
  }

  if $::reaktor::manage_group {
    group { $::reaktor::group:
      ensure => present,
      gid    => $::reaktor::gid,
    }
  }

  if $::reaktor::manage_user {
    user { $::reaktor::user:
      ensure => present,
      home   => $::reaktor::homedir,
      uid    => $::reaktor::uid,
      gid    => $::reaktor::gid,
    } ->
    file { $::reaktor::homedir:
      ensure => directory,
      mode   => '0750',
      owner  => $::reaktor::user,
      group  => $::reaktor::gid,
    }

    Vcsrepo[$::reaktor::_install_dir] {
      require  => File[$::reaktor::homedir]
    }

    if $::reaktor::manage_group {
      User[$::reaktor::user] {
        require => Group[$::reaktor::group]
      }
    }
  }
}
