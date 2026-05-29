# EC2 IAM role 
resource "aws_iam_role" "ec2_ssm_role" {
  name = "ec2-ssm-role"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "ec2.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )

  tags = {
    project = "di_assignment"
    name    = "ec2-ssm-role"
  }
}

# Policy to read HF_TOKEN from SSM Parameter Store
resource "aws_iam_policy" "ssm_hf_token_read" {
  name = "ssm-hf-token-read"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ssm:GetParameter"]
        Resource = "arn:aws:ssm:*:*:parameter/di/hf_token"
      }
    ]
  })

  tags = {
    project = "di_assignment"
    name    = "ssm-hf-token-read"
  }
}

# Attach it to the existing role
resource "aws_iam_role_policy_attachment" "ssm_hf_token_read" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = aws_iam_policy.ssm_hf_token_read.arn
}

# Attach SSM Managed Policy 
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# EC2 Instance Profile 
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm_role.name

  tags = {
    project = "di_assignment"
    name    = "ec2-ssm-profile"
  }
}
