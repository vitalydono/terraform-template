
resource "aws_instance" "cltt_ec2_prod_db" {
  ami                    = "ami-0fcf52bcf5db7b003"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.cltt_sg.id]
  security_groups        = [aws_security_group.cltt_sg.id]
  subnet_id              = aws_subnet.cltt_private_subnet.id
  key_name               = module.cltt_instance_key_pair.key_pair_key_name
  tags = {
    "Name" : "cltt_ec2_prod_db"
  }
  user_data = <<-EOF
    #cloud-config
    packages:
      - mongodb
    runcmd:
      - sudo apt-get update
      - wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
      - echo "deb http://us-west-2.ec2.archive.ubuntu.com/ubuntu/ focal main universe" | sudo tee -a /etc/apt/sources.list
      - sudo apt-get update
      - sudo apt install -y libssl1.1
      - sudo apt-get install -y mongodb
    EOF
}
