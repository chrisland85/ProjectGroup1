terraform {
  backend "s3" {
    bucket = "prod-acs730-projectgroup-ookusolubo" // Bucket where to SAVE Terraform State
    key    = "prod-network/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
    region = "us-east-1"                         // Region where bucket is created
  }
}