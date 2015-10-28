# == Class reaktor::install
#
# This class is called from reaktor for install.
#
class reaktor::install {

  $repodir = "${::reaktor::homedir}/reaktor"

  vcsrepo { $repodir:
    ensure   => present,
    provider => 'git',
    source   => $::reaktor::repository,
    user     => $::reaktor::user,
  }

  if $::reaktor::manage_user {
    group { $::reaktor::user:
      ensure => present,
      gid    => $::reaktor::gid
    }
    user { $::reaktor::user:
      ensure => present,
      uid    => $reaktor::uid,
      gid    => $reaktor::gid,
    }

    # Vcsrepo[$repodir] {
    #   require  => User[$::reaktor::user]
    # }
  }
}
