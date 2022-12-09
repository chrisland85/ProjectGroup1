# Module to deploy webserver
module "vpc-staging" {
  source = "../../../modules/aws_network"
  env                    = var.env
  vpc_cidr               = var.vpc_cidr
  prefix                 = var.prefix
  default_tags           = var.default_tags
  aws_availability_zones = var.aws_availability_zones
}

