resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

module "cltt_instance_key_pair" {
  version    = "1.0.1"
  source     = "terraform-aws-modules/key-pair/aws"
  key_name   = "cltt-instance-kp"
  public_key = tls_private_key.private_key.public_key_openssh
}




