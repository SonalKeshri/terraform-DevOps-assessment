aws_region = "ap-south-1"

vpc_cidr = "10.0.0.0/16"
azs      = ["ap-south-1a", "ap-south-1b"]

ami_id        = "ami-0abcdef1234567890"   # example AMI
instance_type = "t3.micro"

min_size         = 1
max_size         = 2
desired_capacity = 1
