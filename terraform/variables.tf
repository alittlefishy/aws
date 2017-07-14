variable "public_key_path" {
  description = <<DESCRIPTION
Path to the SSH public key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can
connect.

Example: ~/.ssh/terraform.pub
DESCRIPTION

  default = "~/.ssh/terraform.pub"
}

variable "key_name" {
  description = "Desired name of AWS key pair"
  default = "terraform"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-2"
}

variable "subnet_id" {
  description = "AWS subnet"
  default = "subnet-b1453fd8"
}

# Red Hat 
variable "aws_amis" {
  default = {
    us-east-2 = "ami-11aa8c74"
  }
}

variable "instance_type" { default = "t2.micro" }
