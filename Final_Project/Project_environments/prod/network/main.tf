# Module to deploy basic networking 
module "vpc-prod" {
  source = "../../../modules/aws_network"
  # source              = "git@github.com:igeiman/aws_network.git"
  env                    = var.env
  vpc_cidr               = var.vpc_cidr
  prefix                 = var.prefix
  default_tags           = var.default_tags
  aws_availability_zones = var.aws_availability_zones
}

