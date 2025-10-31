variable "project" {
  type    = string
  default = "tf-docker-ansible"
}
variable "container_count" { 
    type = number  
    default = 2 
}
variable "names" { 
    type = list(string) 
    default = ["4IT-1","4IT-2"] 
    }
variable "host_ports" { 
    type = list(number) 
    default = [2221, 2222] 
} # SSH ports on localhost
variable "ssh_user" { 
    type = string 
    default = "ubuntu" 
}
variable "ssh_password" { 
    type = string 
    default = "ubuntu" 
    sensitive = true 
}
