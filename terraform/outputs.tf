output "container_names" {
  value = [for c in docker_container.node : c.name]
}
