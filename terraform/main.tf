locals {
  use_names = slice(var.names, 0, var.container_count)
  use_ports = slice(var.host_ports, 0, var.container_count)
}

# Build the local image from docker/Dockerfile
resource "docker_image" "ubuntu_ssh" {
  name = "${var.project}:ubuntu-ssh"
  build {
    context    = "${path.module}/../docker"
    dockerfile = "Dockerfile"
  }
}

# Create a user-defined network (optional, nice to have)
resource "docker_network" "net" {
  name = "${var.project}-net"
}

# Spin up N containers, each mapping SSH to a distinct host port
resource "docker_container" "node" {
  count = var.container_count

  name  = element(local.use_names, count.index)
  image = docker_image.ubuntu_ssh.image_id
  networks_advanced {
    name = docker_network.net.name
  }

  # Publish host ports for SSH
  ports {
    internal = 22
    external = element(local.use_ports, count.index)
    ip       = "0.0.0.0"
  }

  # Ensure SSH is ready before Ansible (simple healthcheck)
  healthcheck {
    test         = ["CMD", "sh", "-c", "nc -z localhost 22"]
    interval     = "5s"
    timeout      = "3s"
    retries      = 20
    start_period = "5s"
  }
}

# ---- Inventory generation for Ansible (localhost + port) --------------------

data "template_file" "inventory" {
  template = file("${path.module}/inventory.tmpl")
  vars = {
    hosts       = join(",", local.use_names)
    ports       = join(",", [for p in local.use_ports : tostring(p)])
    ssh_user    = var.ssh_user
    ssh_pass    = var.ssh_password
  }
}

resource "local_file" "inventory_file" {
  content  = data.template_file.inventory.rendered
  filename = "${path.module}/../ansible/inventory.ini"
}


