# == Class reaktor::install
#
# This class is called from reaktor for install.
#
class reaktor::install {

  vcsrepo { '/home/reaktor/reaktor':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/pzim/reaktor.git',
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

    Vcsrepo['/home/reaktor/reaktor'] {
      require  => User[$::reaktor::user]
    }
  }
}
