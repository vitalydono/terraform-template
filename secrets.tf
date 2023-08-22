
# resource "aws_key_pair" "cltt_users_key_pairs" {
#   for_each      = { for user in var.users : user.username => user }
#   key_name   = var.users[count.index].username
#   public_key = var.users[count.index].ssh_key
# }
