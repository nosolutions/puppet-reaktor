# == Class reaktor::config
#
# This class is called from reaktor for service config.
#
class reaktor::config {
  file { "${::reaktor::_install_dir}/reaktor-cfg.yml":
    ensure  => present,
    content => template("${module_name}/reaktor-cfg.yml.erb"),
    owner   => $::reaktor::user,
    group   => $::reaktor::group,
    mode    => '0544',
    require => Vcsrepo[$reaktor::_install_dir],
  }

  if $reaktor::manage_masters {
    $masters = $reaktor::masters

    file { "${::reaktor::homedir}/masters":
      ensure  => present,
      content => template("${module_name}/masters.erb"),
      owner   => $::reaktor::user,
      group   => $::reaktor::group,
      mode    => '0544',
      require => Vcsrepo[$reaktor::_install_dir],
    }
  }

  file { "${::reaktor::homedir}/etc/reaktor_environment":
    ensure => file,
    owner   => $::reaktor::user,
    group   => $::reaktor::group,
    mode    => '0644',
    content => template("${module_name}/reaktor_environment.erb"),
    require => Vcsrepo[$reaktor::_install_dir],
  }

  if $::reaktor::notifiers == undef or $::reaktor::notifiers == {} {
    file { "${reaktor::_install_dir}/lib/reaktor/notification/active_notifiers/hipchat.rb":
      ensure => absent
    }
  }
  else {
    create_resources('reaktor::config::notifiers', merge($notifiers_defaults, $reaktor::notifiers), {})
  }
}
