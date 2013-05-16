class varnish::el {
  $version_array = split($operatingsystemrelease, '\.')
  $major_version = $version_array[0]

  yumrepo { 'varnish':
    enabled         => 1,
    descr           => "Varnish 3.0 for Enterprise Linux ${major_version} - \$basearch",
    gpgcheck        => 0,
    baseurl         => "http://repo.varnish-cache.org/redhat/varnish-3.0/el${major_version}/\$basearch",
    priority        => 1,
    name            => 'varnish-3.0',
    before          => Package['varnish']
  }

}
