output "container_names" {
  value = [for c in docker_container.node : c.name]
  description = "All provisioned hosts"
}

output "ssh_commands" {
  value = [
    for idx, name in local.use_names :
    "ssh ${var.ssh_user}@localhost -p ${local.use_ports[idx]}"
  ]
  description = "Convenience SSH commands to each container"
}

output "inventory_path" {
  value = local_file.inventory_file.filename
}