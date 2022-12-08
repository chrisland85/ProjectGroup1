
# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Use remote state to retrieve the data
data "terraform_remote_state" "network" { // This is to use Outputs from Remote State
  backend = "s3"
  config = {
    bucket = "${var.env}-acs730-project-ookusolubo" // Bucket from where to GET Terraform State
    key    = "${var.env}-network/terraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1"                            // Region where bucket created
  }
}


# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Define tags locally
locals {
  default_tags = merge(var.default_tags, { "env" = var.env })
}

# define auto-scaling launch configuration
resource "aws_launch_configuration" "custom-launch-config" {
  //count                       = var.ec2_count
  name = "custom-launch-config"
  // name                        = "custom_launch_config"
  image_id                    = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.web_key.key_name
  //subnet_id                   = element(data.terraform_remote_state.network.outputs.private_subnet_ids, count.index)
  security_groups             = [aws_security_group.web_sg.id]
  associate_public_ip_address = false
  user_data                   = file("${path.module}/install_httpd.sh")

  root_block_device {
    encrypted = var.env == "prod" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }
}

# define auto-scaling group
resource "aws_autoscaling_group" "custom-group-autoscaling" {
  name = "custom-group-autoscaling"
  //count                       = var.ec2_count
  // name                        = "custom_launch_config"
  vpc_zone_identifier       = data.terraform_remote_state.network.outputs.private_subnet_ids
  launch_configuration      = aws_launch_configuration.custom-launch-config.name
  load_balancers            = [aws_elb.web-alb.name]
  min_size                  = 1
  desired_capacity          = var.ec2_count
  max_size                  = 4
  health_check_grace_period = 100
  health_check_type         = "EC2"
  force_delete              = true
  tag {
    key                 = "Name"
    value               = "Group1-${var.env}-webserver_instance"
    propagate_at_launch = true
  }
  
}


# define auto-scaling configuration policy
resource "aws_autoscaling_policy" "custom-cpu-policy" {
  //count                       = var.ec2_count
  name                   = "custom-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.custom-group-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
  policy_type            = "SimpleScaling"

}

# define cloud watch monitoring
resource "aws_cloudwatch_metric_alarm" "custom-cpu-alarm" {
  //count                       = var.ec2_count
  alarm_name          = "custom-cpu-alarm"
  alarm_description   = "alarm once cpu usage increases"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 10

  dimensions = {
    "AutoScalingGroupName" : aws_autoscaling_group.custom-group-autoscaling.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.custom-cpu-policy.arn]

  tags = merge(local.default_tags,
    {
      "Name" = "Group1-${var.env}-cpu-alarm"
    }
  )
}

# define auto-scaling configuration policy for scaling down
resource "aws_autoscaling_policy" "custom-cpu-policy-scaledown" {
  // count                       = var.ec2_count
  name                   = "custom-cpu-policy-scaledown"
  autoscaling_group_name = aws_autoscaling_group.custom-group-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 60
  policy_type            = "SimpleScaling"

}

# define cloud watch monitoring for scaledown
resource "aws_cloudwatch_metric_alarm" "custom-cpu-alarm-scaledown" {
  alarm_name          = "custom-cpu-alarm"
  alarm_description   = "alarm once cpu usage increases"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 5

  dimensions = {
    "AutoScalingGroupName" : aws_autoscaling_group.custom-group-autoscaling.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.custom-cpu-policy-scaledown.arn]

  tags = merge(local.default_tags,
    {
      "Name" = "Group1-${var.env}-cpu-alarm-scaledown"
    }
  )
}



# Adding SSH key to Amazon EC2
resource "aws_key_pair" "web_key" {
  key_name   = var.prefix
  public_key = file(var.path_to_web_key)
  //public_key = file("${var.prefix}.pub")
  tags = merge(local.default_tags,
    {
      "Name" = "Group1-${var.env}-key"
    }
  )
}


# Creating an AWS instance for the Bastion Host, It should be launched in the public Subnet!
resource "aws_instance" "Bastion-Host" {
  depends_on = [
    aws_launch_configuration.custom-launch-config,
  ]

  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.web_key.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  security_groups             = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
 // iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  user_data                   = file("${path.module}/install_httpd.sh")

  root_block_device {
    encrypted = var.env == "prod" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      "Name" = "Group1-${var.env}-Bastion_Host"
    }
  )
}


# Elastic IP
resource "aws_eip" "static_eip" {
  vpc      = true
  instance = aws_instance.Bastion-Host.id
  tags = merge(local.default_tags,
    {
      "Name" = "Group1-${var.env}-eip"
    }
  )
}
