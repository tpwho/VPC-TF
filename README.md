# VPC-TF
Create a VPC-like setup using terraform. This will create a total of 3 droplets with only the "bastion" droplet being able to be ssh'd into from the outside network. The other droplets will be locked down so SSH is only avaliable from the private address of the afforementioned bastion. Communication out is allowed via http/https/DNS/Ping. The droplets can talk to each other over the private network only. SSH key access will be enabled (key needs to be generated ahead of time)
For additional security firewall rules should be setup against the private network to allow only ports in use for the services they are providing.

## Install Tools
Install at least the 0.10 version of [Terraform](https://releases.hashicorp.com/terraform/0.10.0-rc1/) this is needed to support the digitalocean firewall.

## Usage
Clone this repo:

```
git clone https://github.com/tpwho/VPC-TF
cd VPC-TF
```

Edit the `terraform.tfvars` file:

```
do_token = "digital ocean api key"
ssh_key = "path to public ssh key"
```

Initialize terraform to download the provider plugin needed
```
terraform init
```

To create the VPC
```
terraform apply
```

To destroy the VPC
```
teraform destroy
```
