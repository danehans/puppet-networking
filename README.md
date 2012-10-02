This is a puppet module to configure /etc/network/interfaces for OpenStack deployments.
Additional module documentation is coming.

Here is a sample compute node definition that calls the networking::interfaces class.  The networking::interfaces supports the following node types:

   A. Controller
 
   B. Compute
 
   C. Swift Proxy
 
   D. Swift Storage

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

When using the networking::interfaces class, you are no longer required to define ip and domain within cobbler::node of the cobbler-nodes.pp file.  Here is an example cobbler::node node definition:

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