# web public ip
output "web_ip" {
    value = aws_instance.Bastion-Host.public_ip
}