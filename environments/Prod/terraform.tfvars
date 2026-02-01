aws_region = "ap-south-1"

vpc_cidr = "10.1.0.0/16"
azs      = ["ap-south-1a", "ap-south-1b"]

ami_id        = "ami-0abcdef1234567890"   # example
instance_type = "t3.small"

min_size         = 2
max_size         = 5
desired_capacity = 2
