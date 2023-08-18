output "ansible" {
    value = aws_instance.ansible.public_ip
  
}
output "managed" {
    value = aws_instance.managed.public_ip
  
}

