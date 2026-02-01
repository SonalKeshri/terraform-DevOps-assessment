variable "aws_region" {
  description = "AWS region for DEV environment"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR for DEV"
  type        = string
}

variable "azs" {
  description = "Availability Zones for DEV"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for DEV"
  type        = string
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "desired_capacity" {
  type = number
}
