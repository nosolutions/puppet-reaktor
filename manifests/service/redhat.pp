# == Class reaktor::service
#
# This class is meant to be called from reaktor.
# It ensure the service is running.
#
class reaktor::service::redhat {

  $default_config = {
    'RACK_ROOT'                   => $::reaktor::_install_dir,
    'RESQUE_WORKER_USER'          => $::reaktor::user,
    'RESQUE_WORKER_GROUP'         => $::reaktor::group,
    'REAKTOR_PUPPET_MASTERS_FILE' => "${::reaktor::_install_dir}/masters.txt",
  }
  $config = merge($default_config, $::reaktor::config)

  file { '/etc/systemd/system/reaktor.service':
    ensure  => $ensure,
    content => template('reaktor/reaktor.service.erb'),
    mode    => $init_mode,
  }

  service { $::reaktor::service_name:
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => File[$init_file_reaktor],
  }

  if $::reaktor::manage_redis {
    service { $::reaktor::redis_service_name:
      ensure     => 'running',
      enable     => true,
      provider   => $::reaktor::service_provider,
      hasstatus  => true,
      hasrestart => true,
    }
  }
}
