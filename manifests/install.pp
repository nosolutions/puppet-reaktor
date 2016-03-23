# == Class reaktor::install
#
# This class is called from reaktor for install.
#
class reaktor::install {

  class { "::ruby::dev":
  }

  $repodir = $reaktor::_dir

  vcsrepo { $repodir:
    ensure   => present,
    provider => 'git',
    source   => $::reaktor::repository,
    user     => $::reaktor::user,
    notify   => Ruby::Bundle[$repodir],
  }

  unless $::reaktor::build_essentials_package == undef {
    ensure_packages($::reaktor::build_essentials_package)
    Package[$::reaktor::build_essentials_package] {
      before => Ruby::Bundle[$repodir]
    }
  }

  package { 'redis-server':
    ensure   => present,
    provider => 'gem'
  }

  # need to be installed as root
  ruby::bundle { $repodir:
    cwd         => $repodir,
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

    Vcsrepo[$repodir] {
      require  => File[$::reaktor::homedir]
    }

    if $::reaktor::manage_group {
      User[$::reaktor::user] {
        require => Group[$::reaktor::group]
      }
    }
  }
}
