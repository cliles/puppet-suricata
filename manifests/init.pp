# == Class: suricata
#
# Full description of class suricata here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class suricata (
  $package_name       = $suricata::params::package_name,
  $service_name       = $suricata::params::service_name,
  $monitor_interface  = $suricata::params::monitor_interface,
  $netdev_max_backlog = $suricata::params::netdev_max_backlog,
  $rmem_max           = $suricata::params::rmem_max,
  $rmem_default       = $suricata::params::rmem_default ,
  $optmem_max         = $suricata::params::optmem_max
) inherits suricata::params {

  if $::osfamily == 'Debian' { include apt }

  # validate parameters here
  Class['suricata::prepare'] -> Class['suricata::install'] -> Class['suricata::config'] ~> Class['suricata::service']

  class { 'suricata::prepare':
    monitor_interface  => $monitor_interface,
    netdev_max_backlog => $netdev_max_backlog,
    rmem_max           => $rmem_max,
    rmem_default       => $rmem_default,
    optmem_max         => $optmem_max,
  }

  class { 'suricata::install':
    pkgname  => $package_name,
  }

  contain 'suricata::prepare'
  contain 'suricata::install'
  contain 'suricata::config'
  contain 'suricata::service'

}
