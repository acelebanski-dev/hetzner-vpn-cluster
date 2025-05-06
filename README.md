# hetzner-vpn-cluster
This project provisions VPN cluster infrastructure in Hetzner cloud with Terraform

## Solution overview

1. The Terraform code deploys 5 OpenVPN servers and other accompanying cloud infrastructure in Hetzner Cloud.

2. Configuration of the OpenVPN servers is done automatically using Cloud Init (existing PKI was used to generate necessary certificates).

3. Load balancing between the OpenVPN servers is achieved through proper OpenVPN client configuration. Generation of the client OpenVPN profiles is automated using a PowerShell script.

4. MFA is enforced, you need to provide client certificate _(something you have)_ within your OVPN profile, as well as username and password _(something you know)_ while logging in.

## Infrastructure components

The following resources are being deployed in Hetzner Cloud with Terraform:

- 1 Network
- 1 Subnet
- 5 Routes
- 1 Firewall
- 2 SSH Keys
- 5 Primary IPs
- 5 Servers

The following Terraform modules have been developed for that purpose:

- [network](./modules/network/)
- [firewall](./modules/firewall/)
- [loadbalancer](./modules/loadbalancer/) (finally didn't use that one)
- [server](./modules/server/)

## Deployment steps

### Set up PKI infrastructure (optional)

If you do not have your own PKI infrastructure for certificates generation, you can easily build one with EasyRSA:

1. Download and install [EasyRSA v3](https://github.com/OpenVPN/easy-rsa/releases/tag/v3.2.2)
2. Download and install [OpenVPN v2.6+](https://openvpn.net/community-downloads/)
3. Create a folder named `openvpn-ca` within the folder containing this repository
4. Change directory to created folder _(with EasyRSA Shell if on a Windows machine)_
5. Run `easyrsa init-pki` and `easyrsa build-ca nopass` commands and follow the instructions to build the Certificate Authority (CA)
6. Run `easyrsa build-server-full <server_name> nopass` command to generate server certificate
7. Run `easyrsa build-client-full <client_name> nopass` command to generate client certificate
8. Run `easyrsa gen-dh` command to generate a Diffie-Hellman key
9. Run `openvpn --genkey secret pki/ta.key` command to generate an HMAC signature

### Prepare Cloud Init files

In order for the servers to come up with the right configuration, you have to prepare Cloud Init files:

1. In the [deployment](./deployment/) folder, clone the [cloud-init.example.yml](./deployment/cloud-init.example.yml) 5 times with `cloud-initX.yml` name format _(where X is a number from 1 to 5)_
2. In cloned files, replace the X in line 48 _(server 10.8.X.0 255.255.255.0)_ with a number from 1 to 5 or replace the entire subnet so it does not overlap with your network environment and between the files
3. In cloned files, replace the Xs in line 22 _(- to: 10.8.X.0/24\n)_ with numbers from 1 to 5 excluding the number given in the previous step _(subnets from other files)_
4. In cloned files, insert Base64 hashes of the certificates and keys generated in your PKI from line 66 to line 80 _(the hashes of the following files need to be provided: `ca.crt`, `<server_name>.crt`, `<server_name>.key`, `dh2048.pem`, `ta.key`)_
5. In cloned files, insert SHA-512 password hash for your OpenVPN user account in line 14

### Prepare SSH Keys

In order to log into the servers, public SSH Keys need to be provided:

1. Open [terraform.tfvars](./deployment/terraform.tfvars) file and find `ssh_keys` map _(line 100)_
2. You will find 2 objects in the map, each representing a separate SSH Key, add or remove objects depending on how many SSH Keys you want to import
3. In the `path` property, specify the path to your public SSH Key file on the machine you will be running Terraform from

### Provision cloud infrastructure:

1. Go to [deployment](./deployment/) folder
2. Run `terraform init` command
3. Run `terraform plan -out tfplan` command and review the plan
4. Run `terraform apply tfplan` command and wait until the deployment is finished

**Note!** _You will have to type in the Hetzner API Token at runtime when running plan/apply commands._

### Generate OpenVPN client profile

1. Fetch public IPv4 addresses of created servers from the Terraform Output
2. Change directory to [openvpn-clients](./openvpn-clients/) folder
3. Create a new folder named `files` _(it will contain your OpenVPN client profiles)_
4. Open the [base.conf](./openvpn-clients/base.conf) file and replace the 5 lines with remote endpoints with IP addresses of your servers like this: `remote <server_ip> 1194`
5. Open the [make_config.ps1](./openvpn-clients/make_config.ps1) script generating OpenVPN client profiles and provide the right path to your PKI infrastructure folder by modifying the `$KeyDir` variable _(if you followed instructions in this README to create PKI, you do not have to modify anything)_
6. Run the PowerShell script using `.\make_config.ps1 <client_name>` command _(the <client_name> needs to match the name of your client certificate)_
7. Generated client profile file named `<client_name>.ovpn` should appear in the [files](./openvpn-clients/files/) folder

### Connect to VPN

1. Download OpenVPN client application to your client operating system
2. Use the profile generated in the previous section to connect to VPN
3. Provide username and password set within Cloud Init file to log in