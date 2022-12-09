# Instance type
variable "instance_type" {
  default = {
    "prod"    = "t3.medium"
    "test"    = "t3.micro"
    "staging" = "t3.small"
    "dev"     = "t2.micro"
  }
  description = "Type of the instance"
  type        = map(string)
}

# Default tags
variable "default_tags" {
  default = {
    "Owner" = "Oluwole"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Prefix to identify resources
variable "prefix" {
  default     = "project"
  type        = string
  description = "Name prefix"
}


# Variable to signal the current environment 
variable "env" {
  default     = "dev"
  type        = string
  description = "Deployment Environment"
}

# Variable to signal the current environment 
variable "ec2_count" {
  default     = "2"
  type        = number
  description = "Number of instances"
}

variable "path_to_web_key" {
  default     = "/home/ec2-user/.ssh/project.pub"
  description = "Path to the public key to use in webserver"
  type        = string
}

variable "grp" {
  default     = "Group1"
  type        = string
  description = "Deployment Environment"
}





