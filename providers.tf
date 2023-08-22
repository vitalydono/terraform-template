terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  profile = "vitaly"
  region  = var.region
}