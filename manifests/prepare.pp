# == Class suricata::prepare
#
class suricata::prepare (
  $monitor_interface,
  $compile_pkgs,
  $netdev_max_backlog,
  $rmem_max,
  $rmem_default,
  $optmem_max,
) {

  package { 'ethtool':
    ensure => installed,
  }

  service { 'irqbalance':
    ensure => stopped,
    enable => false,
  }

  exec { 'disable_gro':
    command => "/sbin/ethtool -K ${monitor_interface} gro off",
    unless  => "/sbin/ethtool -k ${monitor_interface} | grep 'generic-receive-offload: off'"
  }

  exec { 'disable_rxvlan':
    command => "/sbin/ethtool -K ${monitor_interface} rxvlan off",
    unless  => "/sbin/ethtool -k ${monitor_interface} | grep 'rx-vlan-offload: off'"
  }

  exec { 'disable_gso':
    command => "/sbin/ethtool -K ${monitor_interface} gso off",
    unless  => "/sbin/ethtool -k ${monitor_interface} | grep 'generic-segmentation-offload: off'"
  }

  exec { 'disable_sg':
    command => "/sbin/ethtool -K ${monitor_interface} sg off",
    unless  => "/sbin/ethtool -k ${monitor_interface} | grep 'tcp-segmentation-offload: off'"
  }

  exec { 'disable_rx':
    command => "/sbin/ethtool -K ${monitor_interface} rx off",
    unless  => "/sbin/ethtool -k ${monitor_interface} | grep 'rx-checksumming: off'"
  }

  exec { 'set_promisc':
    command => "/sbin/ifconfig ${monitor_interface} promisc",
    unless  => "/sbin/ifconfig ${monitor_interface} | grep 'PROMISC'"
  }

  if $::osfamily == 'RedHat' {
    package { $compile_pkgs:
      ensure => installed,
    }
  }

  sysctl { 'net.core.netdev_max_backlog':
    ensure    => 'present',
    permanent => 'yes',
    value     => $netdev_max_backlog,
  }

  sysctl { 'net.core.rmem_max':
    ensure    => 'present',
    permanent => 'yes',
    value     => $rmem_max,
  }

  sysctl { 'net.core.rmem_default':
    ensure    => 'present',
    permanent => 'yes',
    value     => $rmem_default,
  }

  sysctl { 'net.core.optmem_max':
    ensure    => 'present',
    permanent => 'yes',
    value     => $optmem_max,
  }

# set max mtu size on monitor interface
# ifconfig em1 mtu 9216
# set max ring size
# ethtool -G eth3 rx 4096

# suricata metrics to watch
# http://pevma.blogspot.nl/2014/08/suricata-flows-flow-managers-and-effect.html
}
