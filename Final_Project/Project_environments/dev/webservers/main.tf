
#----------------------------------------------------------
# ACS730 - Project - Terraform Introduction
#
# Build EC2 Instances
#
#----------------------------------------------------------

# Module to deploy basic networking 
module "webserver-dev" {
  source = "../../../modules/aws_webservers"
  # source              = "git@github.com:igeiman/aws_network.git"
  instance_type   = var.instance_type
  env             = var.env
  ec2_count       = var.ec2_count
  prefix          = var.prefix
  default_tags    = var.default_tags
  path_to_web_key = var.path_to_web_key
}


