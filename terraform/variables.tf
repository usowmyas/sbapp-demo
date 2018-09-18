variable "region" {
  default = "eu-central-1"
}

variable "azs" {
  default = {
    "eu-central-1" = "eu-central-1a,eu-central-1b"

    # use "aws ec2 describe-availability-zones --region us-east-1"
    # to figure out the name of the AZs on every region
  }
}

variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_bastionkey_name" {
  default = "uss"
}

variable "aws_appkey_name" {
  default = "appkey"
}

variable "Contact" {
  default = "sowmya"
}

variable "Environment" {
  default = "test"
}

variable "cpes_ami" {
  default = "ami-9a91b371"
}

variable "cpesr_pwd" {
  default = "changeit"
}

variable "aws_region" {
  description = "EC2 Region for the VPC"
  default     = "eu-central-1"
}

variable "frenv" {
  description = "define the forgerock environmenet"
  default     = "test"
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "10.20.0.0/16"
}

variable "amis" {
  description = "Base AMI to launch the instances NAT and bastion with"

  default = {
    eu-central-1 = "ami-5825cd37"
  }
}

variable "instance_type" {
  default = ""
}

/*
variable "is_ami" {
  description = "AMI to launch applications"

  default = {
    eu-central-1 = "ami-089a6f67"
  }
}
*/

