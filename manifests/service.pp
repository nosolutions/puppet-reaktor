# == Class reaktor::service
#
# This class is meant to be called from reaktor.
# It ensure the service is running.
#
class reaktor::service {

  $user  = $::reaktor::user
  $group = $::reaktor::group
  $dir   = $::reaktor::_install_dir

  case $::reaktor::service_provider {
    'upstart': {
      $init_mode = '0644'
      $init_file_reaktor = "${::reaktor::init_dir}/reaktor.conf"
      $init_file_reaktor_redis   = "${::reaktor::init_dir}/reaktor-redis.conf"

      file { [
        '/etc/init.d/reaktor',
        '/etc/init.d/reaktor-redis'
        ]:
        ensure => 'link',
        target => '/lib/init/upstart-job',
      }
    }
    default: {
      fail('Please, specify one of the following implementd service providers: upstart')
    }
  }

  $default_config = {
    'RACK_ROOT'                   => $dir,
    'RESQUE_WORKER_USER'          => $user,
    'RESQUE_WORKER_GROUP'         => $group,
    'REAKTOR_PUPPET_MASTERS_FILE' => "${dir}/masters.txt",
  }
  $config = merge($default_config, $::reaktor::config)

  file { $init_file_reaktor_redis:
    ensure  => $ensure,
    content => template("${module_name}/upstart_reaktor_redis.erb"),
    mode    => $init_mode,
  } ->
  file { $init_file_reaktor:
    ensure  => $ensure,
    content => template("${module_name}/upstart_reaktor.erb"),
    mode    => $init_mode,
  }

  service { $::reaktor::service_name:
    ensure     => 'running',
    provider   => $::reaktor::service_provider,
    hasstatus  => true,
    hasrestart => true,
    require    => File[$init_file_reaktor, $init_file_reaktor_redis],
  }
}
