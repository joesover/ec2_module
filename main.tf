terraform {
  required_version = ">= 0.12.28" # Restricting Terraform version

  required_providers {
    aws = {
      version = "~> 3.0"
    }
  }
}

variable "instance_names" {
  description = "List of instance names"
  type        = list(string)
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "example" {
  for_each = toset(var.instance_names)  # Convert list to set for compatibility

  ami           = "ami-00710ab5544b60cf7"
  instance_type = "t2.micro"

  tags = {
    Name = each.value
  }
}

output "instance_ids" {
  value = [for instance in aws_instance.example : instance.id]
}