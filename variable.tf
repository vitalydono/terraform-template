variable "region" {
  type    = string
  default = "us-west-2"
}

variable "ami_name" {
  type    = string
  default = "ami-0fcf52bcf5db7b003"
}

variable "certificate_arn" {
  type    = string
  default = "arn:aws:acm:us-west-2:679134032050:certificate/39ccb7c8-d59f-4e35-96e4-f05fb8b27f47"
}

variable "ingressrules" {
  type    = list(number)
  default = [80, 443, 22]
}

variable "egressrules" {
  type    = list(number)
  default = [80, 443, 22]
}

variable "stage" {
  type = string
}
variable "tags" {
  type = map(any)
  default = {
    Name = "cltt-kp"
  }
}

variable "users" {
  type = list(object({
    username = string
    ssh_key  = string
  }))
  default = [
    {
      username = "vitaly_sama"
      ssh_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDBH+Ijl2WHg0YHoLLAHM4FY/9vFOrcp+W7ZiEZXaTDONgoYwUz1WwY0uMolaGtd0v/hGSS/aJvA9lull1BrI0JkVXoy+AKHUajovLHB1YOV7HFf9OLsn+ROcVqYocAQX47FHbJpmCZgJBAyfzMVIsPTQlRVv9DgNbdc+BckCJWfLuQFUqg8jxujAU5rD+8Izcltv21XaF/QHPqDj/yiJmOyAwq5zTGljGgHEmZWhFTWeCPl3wvH6zGAfP2ns3Uo3D1sylGFdtRpoF55RYrbIWOq7tqYO3pD7Zw/54ryQ6G2Dii9fZXx6rjM/Qbjs0TvcwQ6ibKR8gVRmEkB/dc+pNVUyvxoMumKLaUGdscbXBVfSmGN0fqXJ0hLA6F+xoQMjdJ2ownHtO+lgbHgPEWrRWwrLRqcVRl13vLZ5rdIHSTZ8sZTeZ+yWCVkzS913/zfHEwetB6zYbqg1omHqntKnpWbraYheAzzcO+zg9XtmrbIFgd+iEIS0FLv9aPk/MwCol13uV5O9NYxbI7iemEV9be1J82zdyi84Dw4pXyqgpxdSHbkl7dLF/lNQyWKj0IeNGcS+DP+UY3ZDr9+At01nb6JJJSXB0IK8B5riqlhwFppPnyIk6am96hUZ7tR6FltFuoCKznqeiAUIaTgQuDx5/gHXZgZ788/ObeSUxQi8CQZQ== vitlpliss@gmail.com"
    },
    {
      username = "vitaly_dono"
      ssh_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDBH+Ijl2WHg0YHoLLAHM4FY/9vFOrcp+W7ZiEZXaTDONgoYwUz1WwY0uMolaGtd0v/hGSS/aJvA9lull1BrI0JkVXoy+AKHUajovLHB1YOV7HFf9OLsn+ROcVqYocAQX47FHbJpmCZgJBAyfzMVIsPTQlRVv9DgNbdc+BckCJWfLuQFUqg8jxujAU5rD+8Izcltv21XaF/QHPqDj/yiJmOyAwq5zTGljGgHEmZWhFTWeCPl3wvH6zGAfP2ns3Uo3D1sylGFdtRpoF55RYrbIWOq7tqYO3pD7Zw/54ryQ6G2Dii9fZXx6rjM/Qbjs0TvcwQ6ibKR8gVRmEkB/dc+pNVUyvxoMumKLaUGdscbXBVfSmGN0fqXJ0hLA6F+xoQMjdJ2ownHtO+lgbHgPEWrRWwrLRqcVRl13vLZ5rdIHSTZ8sZTeZ+yWCVkzS913/zfHEwetB6zYbqg1omHqntKnpWbraYheAzzcO+zg9XtmrbIFgd+iEIS0FLv9aPk/MwCol13uV5O9NYxbI7iemEV9be1J82zdyi84Dw4pXyqgpxdSHbkl7dLF/lNQyWKj0IeNGcS+DP+UY3ZDr9+At01nb6JJJSXB0IK8B5riqlhwFppPnyIk6am96hUZ7tR6FltFuoCKznqeiAUIaTgQuDx5/gHXZgZ788/ObeSUxQi8CQZQ== vitlpliss@gmail.com"
    }

  ]
}