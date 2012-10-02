# Manages /etc/network/interfaces file
# Example using VLAN networking with the management interface also acting as the public interface.
#node /<node_name>/ inherits base {
#
#  # Configure /etc/network/interfaces file
#  class { 'networking::interfaces':
#    # Node Types: controller, compute, swift-proxy, or swift-storage
#    node_type           => compute,
#    mgt_is_public       => true,
#    vlan_networking     => true,
#    vlan_interface      => "eth0",
#    mgt_interface       => "eth0",
#    mgt_ip              => "192.168.220.53",
#    mgt_gateway         => "192.168.220.1",
#    flat_vlan           => "221",
#    dns_servers         => "192.168.220.254",
#    dns_search          => "dmz-pod2.lab",
# }
#}

class networking::interfaces(
        $node_type,
        $vlan_networking   = false,
	$mgt_is_public     = false,
        $vlan_interface    = 'eth0',
        $mgt_interface     = 'eth0',
        $mgt_ip,
        $mgt_mask          = '255.255.255.0',
        $mgt_gateway,
	$flat_interface    = undef,
	$flat_vlan         = undef,
	$flat_ip           = undef,
        $flat_mask         = '255.255.255.0',
        proxy_interface    = undef,
        $proxy_vlan        = undef,
        $proxy_ip          = undef,
	$proxy_mask        = '255.255.255.0',
	$public_interface  = undef,
        $public_vlan       = undef,
	$public_ip         = undef,
	$public_mask       = '255.255.255.0',
	$storage_interface = undef,
        $storage_vlan      = undef,
        $storage_ip        = undef,
        $storage_mask      = '255.255.255.0',
        $dns_servers,
        $dns_search)
{

 if ($vlan_networking == true) and ($mgt_is_public == false) {
 
  #use template to manage /network/interfaces file
  file { "/etc/network/interfaces":
   owner   => root,
   group   => root,
   mode    => 644,
   content => template("networking/vlan/$node_type")
  }
 
  # Restarts VLAN networking after conf file changes
  exec { 'network-restart':
    command     => "/etc/init.d/networking restart",
    logoutput   => on_failure,
    subscribe   => File["/etc/network/interfaces"],
    refreshonly => true,
    path        => '/sbin/:/usr/sbin/:/usr/bin/:/bin/',
  }
 } 

 elsif ($vlan_networking == true) and ($mgt_is_public == true) {

  #use template to manage /network/interfaces file
  file { "/etc/network/interfaces":
   owner   => root,
   group   => root,
   mode    => 644,
   content => template("networking/vlan/mgt_is_public/$node_type")
  }

  # Restarts VLAN networking after conf file changes
  exec { 'network-restart':
    command     => "/etc/init.d/networking restart",
    logoutput   => on_failure,
    subscribe   => File["/etc/network/interfaces"],
    refreshonly => true,
    path        => '/sbin/:/usr/sbin/:/usr/bin/:/bin/',
  }
 }

 elsif ($vlan_networking == false) and ($mgt_is_public == true) {

  #use template to manage /network/interfaces file
  file { "/etc/network/interfaces":
   owner   => root,
   group   => root,
   mode    => 644,
   content => template("networking/mgt_is_public/$node_type")
  }
    
  # Restarts VLAN networking after conf file changes
  exec { 'network-restart':
    command     => "/etc/init.d/networking restart",
    logoutput   => on_failure,
    subscribe   => File["/etc/network/interfaces"],
    refreshonly => true,
    path        => '/sbin/:/usr/sbin/:/usr/bin/:/bin/',
  }
 } else {
  
  #use template to manage /network/interfaces file
  file { "/etc/network/interfaces":
    owner   => root,
    group   => root,
    mode    => 644,
    content => template("networking/$node_type")
  }

  # Restarts networking after conf file changes
  exec { 'network-restart':
    command     => "/etc/init.d/networking restart",
    logoutput   => on_failure,
    subscribe   => File["/etc/network/interfaces"],
    refreshonly => true,
    path        => '/sbin/:/usr/sbin/:/usr/bin/:/bin/',
  }
 }
}
