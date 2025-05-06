name_prefix = "ac-"
global_labels = {
  "Creator" : "AC"
  "Created_With" : "Terraform"
}

zone       = "eu-central"
location   = "nbg1"
datacenter = "nbg1-dc3"

networks = {
  "server_network" = {
    name     = "server-net"
    ip_range = "10.0.0.0/24"
    subnets = {
      "server_subnet" = {
        ip_range = "10.0.0.0/25"
      }
    }
    routes = {
      "to_vpn_server1" = {
        destination = "10.8.1.0/24"
        gateway     = "10.0.0.2"
      }
      "to_vpn_server2" = {
        destination = "10.8.2.0/24"
        gateway     = "10.0.0.3"
      }
      "to_vpn_server3" = {
        destination = "10.8.3.0/24"
        gateway     = "10.0.0.4"
      }
      "to_vpn_server4" = {
        destination = "10.8.4.0/24"
        gateway     = "10.0.0.5"
      }
      "to_vpn_server5" = {
        destination = "10.8.5.0/24"
        gateway     = "10.0.0.6"
      }
    }
  }
}

firewalls = {
  "server_firewall" = {
    name = "server-fw"
    rules = {
      "allow_ssh_in" = {
        description = "Allow inbound SSH to the servers"
        direction   = "in"
        protocol    = "tcp"
        port        = "22"
        source_ips  = ["77.65.106.146/32"]
      }
      "allow_openvpn_udp1194_in" = {
        description = "Allow inbound OpenVPN UDP 1194 to the servers"
        direction   = "in"
        protocol    = "udp"
        port        = "1194"
        source_ips  = ["0.0.0.0/0"]
      }
      "allow_tcp_local_in" = {
        description = "Allow local TCP traffic within the private network"
        direction   = "in"
        protocol    = "tcp"
        port        = "any"
        source_ips  = ["10.0.0.0/24", "10.8.0.0/16"]
      }
      "allow_icmp_in" = {
        description = "Allow inbound ICMP to the servers"
        direction   = "in"
        protocol    = "icmp"
        source_ips  = ["10.0.0.0/24", "10.8.0.0/16", "77.65.106.146/32"]
      }
      "allow_all_tcp_out" = {
        description     = "Allow all TCP outbound traffic"
        direction       = "out"
        protocol        = "tcp"
        port            = "any"
        destination_ips = ["0.0.0.0/0"]
      }
      "allow_all_udp_out" = {
        description     = "Allow all UDP outbound traffic"
        direction       = "out"
        protocol        = "udp"
        port            = "any"
        destination_ips = ["0.0.0.0/0"]
      }
      "allow_all_icmp_out" = {
        description     = "Allow all ICMP outbound traffic"
        direction       = "out"
        protocol        = "icmp"
        destination_ips = ["0.0.0.0/0"]
      }
    }
  }
}

ssh_keys = {
  "my_key" = {
    name = "ssh-pubkey1"
    path = "~/.ssh/id_rsa.pub"
  }
  "client_key" = {
    name = "ssh-pubkey2"
    path = "./id_rsa.pub"
  }
}

servers = {
  "server1" = {
    name             = "server1"
    network_key      = "server_network"
    firewall_key     = "server_firewall"
    loadbalancer_key = "server_loadbalancer"
    private_ip       = "10.0.0.2"
    user_data_path   = "./cloud-init1.yml"
  }
  "server2" = {
    name             = "server2"
    network_key      = "server_network"
    firewall_key     = "server_firewall"
    loadbalancer_key = "server_loadbalancer"
    private_ip       = "10.0.0.3"
    user_data_path   = "./cloud-init2.yml"
  }
  "server3" = {
    name             = "server3"
    network_key      = "server_network"
    firewall_key     = "server_firewall"
    loadbalancer_key = "server_loadbalancer"
    private_ip       = "10.0.0.4"
    user_data_path   = "./cloud-init3.yml"
  }
  "server4" = {
    name             = "server4"
    network_key      = "server_network"
    firewall_key     = "server_firewall"
    loadbalancer_key = "server_loadbalancer"
    private_ip       = "10.0.0.5"
    user_data_path   = "./cloud-init4.yml"
  }
  "server5" = {
    name             = "server5"
    network_key      = "server_network"
    firewall_key     = "server_firewall"
    loadbalancer_key = "server_loadbalancer"
    private_ip       = "10.0.0.6"
    user_data_path   = "./cloud-init5.yml"
  }
}
