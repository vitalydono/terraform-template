
resource "aws_subnet" "cltt_private_subnet" {
  vpc_id            = aws_vpc.cltt_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.region}a"
  tags = {
    "Name" = "codelovers_private_subnet"
  }
}

resource "aws_eip" "cltt_nat_gateway_eip" {
  vpc = true
}

resource "aws_nat_gateway" "cltt_ng" {
  allocation_id = aws_eip.cltt_nat_gateway_eip.id
  subnet_id     = aws_subnet.cltt_public_subnet.id
}


resource "aws_route_table" "cltt_private_rt" {
  vpc_id = aws_vpc.cltt_vpc.id
  tags = {
    "Name" = "codelovers_private_rt"
  }
}

resource "aws_route_table_association" "cltt_private_assoc" {
  subnet_id      = aws_subnet.cltt_private_subnet.id
  route_table_id = aws_route_table.cltt_private_rt.id
}

resource "aws_route" "cltt_private_route" {
  route_table_id         = aws_route_table.cltt_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.cltt_ng.id
}

resource "aws_instance" "cltt_ec2_bastion_host" {
  ami                    = "ami-0fcf52bcf5db7b003"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.cltt_sg_bastion.id]
  security_groups        = [aws_security_group.cltt_sg_bastion.id]
  subnet_id              = aws_subnet.cltt_public_subnet.id
  key_name               = module.cltt_instance_key_pair.key_pair_key_name
  tags = {
    "Name" : "cltt_ec2_bastion_host",
  }
}

resource "aws_instance" "cltt_ec2_admin" {
  ami                    = "ami-0fcf52bcf5db7b003"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.cltt_sg.id]
  security_groups        = [aws_security_group.cltt_sg.id]
  subnet_id              = aws_subnet.cltt_public_subnet.id
  key_name               = module.cltt_instance_key_pair.key_pair_key_name
  tags = {
    "Name" : "cltt_ec2_admin",
  }
  user_data = <<-EOF
    #cloud-config
    packages:
      - git
      - nodejs
      - docker.io
      - docker-compose
    runcmd:
      - curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
      - sudo apt-get update
  EOF
}

resource "null_resource" "create_users" {
  count = length(var.users)

  provisioner "remote-exec" {
    inline = [
      "sudo adduser --disabled-password --gecos '' ${var.users[count.index].username}",
      "echo '${var.users[count.index].username} ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/${var.users[count.index].username}",
      "sudo mkdir -p /home/${var.users[count.index].username}/.ssh",
      "sudo touch /home/${var.users[count.index].username}/.ssh/authorized_keys",
      "echo '${var.users[count.index].ssh_key}' | sudo tee /home/${var.users[count.index].username}/.ssh/authorized_keys",
      "sudo chown -R ${var.users[count.index].username}:${var.users[count.index].username} /home/${var.users[count.index].username}/.ssh",
      "sudo chmod 755 /home/${var.users[count.index].username}",
      "sudo chmod 755 /home/${var.users[count.index].username}/.ssh",
      "sudo chmod 755 /home/${var.users[count.index].username}/.ssh/authorized_keys",
      "sudo chmod 600 /home/${var.users[count.index].username}/.ssh/authorized_keys"
    ]

    connection {
      type        = "ssh"
      host        = aws_instance.cltt_ec2_admin.public_ip
      user        = "ubuntu"
      private_key = tls_private_key.private_key.private_key_pem

    }
  }
}
