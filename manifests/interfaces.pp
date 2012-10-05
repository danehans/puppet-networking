# The networking::interfaces class manages /etc/network/interfaces file parameters.
# The class is focused on Ubuntu-based OpenStack deployments, but it can be extended to support various requirements.
#
# Parameters:
# - $node_type (required) Specifies the OpenStack node type.  Options are: controller, compute, swift-proxy, swift-storage.
# - $vlan_networking set to true if you are using VLAN's for private/public networks.
# - $mgt_is_public set to true if the management interface (i.e. eth0) will also act as the OpenStack public network.
# - $vlan_interface specifies which interface is being used for VLAN networking.
# - $mgt_interface specifies which interface is being used to manage the node.
# - $mgt_ip (required) specifies the IP address that will be assigned to the management interface.
# - $mgt_mask the netmask of the management interface
# - $mgt_gateway the default gateway for the management network.
# - $flat_interface (required for compute/controller $node_type) specifies the nova networking flat interface.
# - $flat_vlan (required for compute/controller $node_type with $vlan_networking = true) specifies the nova networking flat VLAN.
# - $flat_ip (required for controller $node_type) specifies the nova networking flat interface ip address.
# - $flat_mask (required for controller $node_type) specifies the nova networking flat interface netmask.
# - $proxy_interface (required for swift-proxy $node_type) specifies the Swift Proxy interface.
# - $proxy_vlan (required for swift-proxy $node_type with $vlan_networking = true) specifies the Swift Proxy VLAN.
# - $proxy_ip (required for swift-proxy $node_type) specifies the Swift Proxy interface ip address.
# - $proxy_mask (required for swift-proxy $node_type) specifies the Swift Proxy interface netmask.
# - $public_interface (required for compute $node_type) specifies the nova networking public interface.
# - $public_vlan (required for compute $node_type with $vlan_networking = true) specifies the nova networking Public VLAN.
# - $public_ip (required for compute $node_type) specifies the nova networking Public interface ip address.
# - $public_mask (required for compute $node_type) specifies the nova networking Public interface netmask.
# - $storage_interface (required for swift-storage $node_type) specifies the Swift Storage interface.
# - $storage_vlan (required for swift-storage $node_type with $vlan_networking = true) specifies the Swift storage VLAN.
# - $storage_ip (required for swift-storage $node_type) specifies the Swift storage interface ip address.
# - $storage_mask (required for swift-storage $node_type) specifies the Swift storage interface netmask.
# - $dns_servers (required) specifies the IP address(es) of DNS name servers.
# - $dns_search (required) specifies the DNS suffix of Node FQDN.
#
# This Compute Node example uses VLAN networking with the management interface also acting as the public interface.
#node /<node_name>/ inherits base {
#
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
