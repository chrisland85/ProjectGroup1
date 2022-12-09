
# Module to deploy basic networking 
module "vpc-dev" {
  source = "../../../modules/aws_network"
  env                    = var.env
  vpc_cidr               = var.vpc_cidr
  prefix                 = var.prefix
  default_tags           = var.default_tags
  aws_availability_zones = var.aws_availability_zones
  grp                    = var.grp
}


