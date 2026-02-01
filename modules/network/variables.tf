variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "List of Availability Zones to spread resources across"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}
