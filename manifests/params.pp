# == Class suricata::params
#
# This class is meant to be called from suricata
# It sets variables according to platform
#
class suricata::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'suricata'
      $service_name = 'suricata'
      $monitor_interface = 'eth1'
    }
    'RedHat', 'Amazon': {
      $package_name = 'suricata'
      $service_name = 'suricata'
      $monitor_interface = 'eth1'
      $compile_pkgs = [
        'gcc',
        'libpcap-devel',
        'pcre-devel',
        'libyaml-devel',
        'file-devel', 
        'zlib-devel',
        'jansson-devel',
        'nss-devel',
        'libcap-ng-devel',
        'libnet-devel',
        'libnetfilter_queue-devel',
      ]
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }

  $netdev_max_backlog = 250000
  $rmem_max           = 16777216
  $rmem_default       = 16777216
  $optmem_max         = 16777216

}
