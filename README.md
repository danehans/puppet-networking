This is a puppet module to configure /etc/network/interfaces for OpenStack deployments.  The networking::interfaces class supports the following node types:

   A. Controller
 
   B. Compute
 
   C. Swift Proxy
 
   D. Swift Storage

Here is a sample compute node definition that calls the networking::interfaces class.  This example uses VLANs (100) to seperate the private (Nova Flat) network from the public/management network.

    # Puppet node definition
    node /<compute_node>/ {

      class { 'networking::interfaces':
      # Node Types: controller, compute, swift-proxy, or swift-storage
        node_type           => compute,
        mgt_is_public       => true,
        vlan_networking     => true,
        vlan_interface      => "eth0",
        mgt_interface       => "eth0",
        mgt_ip              => "192.168.10.10",
        mgt_gateway         => "192.168.10.1",
        flat_vlan           => "100",
        dns_servers         => "192.168.254.254",
        dns_search          => "myco.com",
      }
    }
    
Here is a sample compute node definition that calls the networking::interfaces class.  This example uses physcial interface (eth0 and eth1) to seperate the private (Nova Flat) network from the public/management network.

    # Configure /etc/network/interfaces file
    class { 'networking::interfaces':
    # Node Types: controller, compute, swift-proxy, or swift-storage
    node_type           => compute,
    mgt_is_public       => true,
    mgt_interface       => "eth0",
    mgt_ip              => "192.168.220.53",
    mgt_gateway         => "192.168.220.1",
    flat_interface      => "eth1",
    dns_servers         => "192.168.220.254",
    dns_search          => "dmz-pod2.lab",
     }
    }

Here is a sample controller node definition that calls the networking::interfaces class.  This example uses physcial interface (eth0 and eth1) to seperate the private (Nova Flat) network from the public/management network.  The primary difference between compute and controller is assigning an IP address to the flat interface.

    # Configure /etc/network/interfaces file
    class { 'networking::interfaces':
    # Node Types: controller, compute, swift-proxy, or swift-storage
    node_type           => compute,
    mgt_is_public       => true,
    mgt_interface       => "eth0",
    mgt_ip              => "192.168.220.53",
    mgt_gateway         => "192.168.220.1",
    flat_interface      => "eth1",
    flat_ip             => "<ipaddrofnovaflat_net>"
    #add flat_mask if the net is not a /24
    dns_servers         => "192.168.220.254",
    dns_search          => "dmz-pod2.lab",
     }
    }

OPTIONAL: When using the networking::interfaces class, you are no longer required to define ip and domain within cobbler::node of the cobbler-nodes.pp file.  Here is an example cobbler::node node definition:

    cobbler::node { "<compute_node>":
      mac => "A4:4C:11:13:11:AA",
      profile => "precise-x86_64-auto",
      preseed => "/etc/cobbler/preseeds/cisco-preseed",
      power_address => "192.168.254.6",
      power_type => "ipmitool",
      power_user => "admin",
      power_password => "password",
    }

To use the networking puppet module:

    cd ./puppet/modules
    git clone https://github.com/danehans/puppet-networking.git networking

Additional documentation is coming.
