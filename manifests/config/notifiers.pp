# == Define reaktor::config::notifiers
#
# This class is called from reaktor::config for configuring the notifiers.
#
define reaktor::config::notifiers(
  $link   = undef,
  $ensure = 'present',
  $owner  = $reaktor::user,
  $group  = $reaktor::group,
  $target = undef
) {
  $link_ensure = $ensure ? {
    'present' => 'link',
    true      => 'link',
    default   => $ensure
  }

  $_link = $link ? {
    undef   => "${reaktor::_dir}/lib/reaktor/notification/active_notifiers/${title}",
    default => $link,
  }

  $_target = $target ? {
    undef   => "../available_notifiers/${title}",
    default => $target
  }

  file { $_link:
    ensure  => $link_ensure,
    owner   => $owner,
    group   => $group,
    require => Vcsrepo[$reaktor::_dir],
  }

  if $link_ensure == 'link' {
    File[$_link] {
      target => $_target
    }
  }
}
