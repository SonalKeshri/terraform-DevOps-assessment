module "network" {
  source = "../../modules/network"

  vpc_cidr = var.vpc_cidr
  azs      = var.azs
}

module "security" {
  source = "../../modules/security"

  vpc_id = module.network.vpc_id
}

module "alb" {
  source = "../../modules/alb"

  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
}

module "compute" {
  source = "../../modules/compute"

  ami_id             = var.ami_id
  instance_type      = var.instance_type
  private_subnet_ids = module.network.private_subnet_ids
  security_group_id  = module.security.ec2_security_group_id
  target_group_arn   = module.alb.target_group_arn

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity
}

module "observability" {
  source = "../../modules/observability"

  asg_name = module.compute.asg_name
}
