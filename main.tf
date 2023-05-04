terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.38.2"
    }
  }
}

variable "hcloud_token" {
  sensitive = true
}

provider "hcloud" {
  token = var.hcloud_token
}

### Variables 
variable "vm_name" {
  default = "default-name"
}

variable "vm_size" {
  default = "cx11"
}

resource "hcloud_ssh_key" "default" {
  name = "SSH"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCfs7blPCApc/MTSUCp8Mmwe0fcDdpQh309vhNed6SgRLtmGqUUPrcMUC8ydtro2o+kTQq8keCmKoM7cSDrngsGJUabw/bMV+xED3ybZCI7+lKpwKNEzNXWuutjj5WACftsMH5R8zoxZ9q0IrLWqJu+jAds69R7apGmrJp/+Q22HRwnFYW4seqCqsKlpHxMNx4FEDn51g4RWnhySHQT6KFwTGLz3xgH0a+4t4H/PgA6sz2QlQ2HsvFZVXUCmUoZkvGDNBjrWvonSPm4UJVQ/1M8pLFrTDiwozMoM9ahq57FyeiM5i5O1AnIQGopuvqfn+9c/VrBy7mLQcHBgk0N5ulEMTmkNOzi54fpEzmssK+Ikx+Ck+5L7O615WlAuoXuQswYNLu3W7B3ZNYdwMm9XyntXuBUqwkVAEgbuaNrbYbeULEX9ge9RP9ua3K8fN0g2rlT+SM5KRlQ7agkbvVboOnVFTLTNd2VYxd3RC7gNdxgaStyDVvCGip83V8/NG449hc="
}

### Creating resources
resource "hcloud_primary_ip" "primary_ip_1" {
name          = "primary_ip_test"
datacenter    = "fsn1-dc14"
type          = "ipv4"
assignee_type = "server"
auto_delete   = true
}

resource "hcloud_server" "server" {
  name        = var.vm_name
  image       = "fedora-38"
  server_type = var.vm_size
  datacenter  = "fsn1-dc14"
  ssh_keys = [ "SSH" ]
  public_net {
    ipv4_enabled = true
    ipv4 = hcloud_primary_ip.primary_ip_1.id
    ipv6_enabled = false
  }
}

output "server_ip" {
  value = hcloud_primary_ip.primary_ip_1.ip_address
}