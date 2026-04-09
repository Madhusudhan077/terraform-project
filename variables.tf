variable "region" {
  default = "eu-north-1"   # Stockholm region
}

variable "key_name" {
  description = "Name of the existing AWS key pair"
}

variable "instance_type" {
  default = "t3.micro"     # Free tier eligible in eu-north-1
}

variable "ami_id" {
  description = "AMI ID for Amazon Linux 2 in eu-north-1"
}

