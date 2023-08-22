
resource "aws_instance" "cltt_ec2_prod_web" {
  ami                    = "ami-0fcf52bcf5db7b003"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.cltt_sg.id]
  security_groups        = [aws_security_group.cltt_sg.id]
  subnet_id              = aws_subnet.cltt_private_subnet.id
  key_name               = module.cltt_instance_key_pair.key_pair_key_name
  tags = {
    "Name" : "cltt_ec2_prod_web"
  }
  user_data = <<-EOF
    #cloud-config
    packages:
      - nginx
      - redis-server
    runcmd:
      - sudo apt-get update
      - systemctl enable redis-server
      - systemctl start redis-server
      - systemctl enable nginx
      - systemctl start nginx
    EOF
}
