# == Class reaktor::config
#
# This class is called from reaktor for service config.
#
class reaktor::config {
  $address              = $::reaktor::address
  $port                 = $::reaktor::port
  $servers              = $::reaktor::servers
  $max_conns            = $::reaktor::max_conns
  $max_persistent_conns = $::reaktor::max_persistent_conns
  $timeout              = $::reaktor::timeout
  $environment          = $::reaktor::environment
  $pid                  = $::reaktor::pid
  $log                  = $::reaktor::log
  $deamonize            = $::reaktor::deamonize

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

    file { "${::reaktor::_install_dir}/masters.txt":
      ensure  => present,
      content => template("${module_name}/masters.txt.erb"),
      owner   => $::reaktor::user,
      group   => $::reaktor::group,
      mode    => '0544',
      require => Vcsrepo[$reaktor::_install_dir],
    }
  }
  
  $notifiers_defaults = {
    'hipchat.rb' => {
      ensure => present,
    }
  }

  create_resources('reaktor::config::notifiers', merge($notifiers_defaults, $reaktor::notifiers), {})
}
