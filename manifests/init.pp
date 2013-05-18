class varnish::install {

  package { 'varnish':
    name    => $varnish::params::package,
    ensure  => $varnish::params::version,
  }
}

class varnish::service {
  service { 'varnish':
    ensure      => running,
    name => $varnish::params::service,
    hasstatus   => true,
    hasrestart  => true,
    enable      => true,
    require     => Class['varnish::install'],
  }
}

class varnish::config {
  $backend_host       = $varnish::params::backend_host
  $backend_port       = $varnish::params::backend_port
  $default_vcl        = $varnish::params::default_vcl
  $listen_port        = $varnish::params::listen_port
  $listen_host        = $varnish::params::listen_host
  $admin_listen_host  = $varnish::params::admin_listen_host
  $admin_listen_port  = $varnish::params::admin_listen_port
  $purge_ips          = $varnish::params::purge_ips

  file {
    'varnish/default.vcl':
      path      => $varnish::params::default_vcl,
      require   => Class['varnish::install'],
      notify    => Class['varnish::service'],
      content   => template('varnish/default.vcl.erb')
  }

  file {
    'varnish/sysconfig':
      path      => $varnish::params::sysconfig,
      require   => Class['varnish::install'],
      notify    => Class['varnish::service'],
      content   => template('varnish/sysconfig.erb')
  }
}


class varnish {
  include varnish::params

  case $::osfamily {
    'RedHat': {
      anchor { 'varnish::begin': } ->
      class { 'varnish::el': } ->
      class { 'varnish::install': } ->
      class { 'varnish::config': } ->
      class { 'varnish::service': } ->
      anchor { 'varnish::end':
        require => Anchor['varnish::begin']
      }

    }
    default:  { notify { "Class[varnish] does not support $::osfamily": } }
  }
}
