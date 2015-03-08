# == Class suricata::install
#
class suricata::install(
  $pkgname
)
{

  if $::osfamily == 'Debian' {
    apt::ppa { 'ppa:oisf/suricata-stable': }
    $reqs = Apt::Ppa['ppa:oisf/suricata-stable']

  }
  else {
    yumrepo { 'suricata':
      ensure   => present,
      baseurl  => 'http://codemonkey.net/files/rpm/suricata/el7',
      enabled  => true,
      gpgcheck => false,
    }
    $reqs = Yumrepo['suricata']
  }

  package { $pkgname:
    ensure  => present,
    require => $reqs 
  }

}
