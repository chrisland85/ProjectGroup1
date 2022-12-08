# creating IAM Policy
//resource "aws_iam_role_policy" "ec2_policy" {
 // name = "ec2_policy"
 // role = aws_iam_role.ec2_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  //policy = jsonencode({
  //  Version = "2012-10-17"
  //  Statement = [
  //    {
  //      Action = [
  //        "ec2:*",
  //      ]
 //       Effect   = "Allow"
  //      Resource = "*"
//      },
  //  ]
//  })
//}

# IAM role creation
//resource "aws_iam_role" "ec2_role" {
 // name = "ec2_role"

 // assume_role_policy = jsonencode({
  //  Version = "2012-10-17"
  //  Statement = [
   //   {
   //     Action = "sts:AssumeRole"
    //    Effect = "Allow"
   //     Sid    = ""
    //    Principal = {
    //      Service = "ec2.amazonaws.com"
     //   }
     // },
   // ]
 // })
//}

# creation connection
//esource "aws_iam_instance_profile" "ec2_profile" {
//    name = "ec2_profile"
//    role = aws_iam_role.ec2_role.name
//}