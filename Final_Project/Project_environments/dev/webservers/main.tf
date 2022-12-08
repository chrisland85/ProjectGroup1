
#----------------------------------------------------------
# ACS730 - Project - Terraform Introduction
#
# Build EC2 Instances
#
#----------------------------------------------------------

#  Define the provider
provider "aws" {
  region = "us-east-1"
  access_key  = var.access_key
  secret_key  = var.secret_key
}

resource "aws_s3_bucket" "mywebpage" {
  bucket    = "${var.env}-acs730-group1project-ookusolubo"
  acl      = "private"

}

resource "aws_s3_bucket_object" "object1" {
  for_each  = fileset("html/", "*")
  bucket    = aws_s3_bucket.mywebpage.id
  key       = each.value
  source    = "html/${each.value}"
  etag      = filemd5("html/${each.value}")
  content_type = "text/html"
}


