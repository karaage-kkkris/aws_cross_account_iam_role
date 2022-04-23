# Assume role policy allowing ec2 to assume this role
data "aws_iam_policy_document" "ec2" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
      ]
    }
  }
}

# Create IAM role and associated instance profile for testing from the ec2
resource "aws_iam_role" "iam_role" {
  name                 = local.name
  permissions_boundary = var.permissions_boundary
  assume_role_policy   = data.aws_iam_policy_document.ec2.json
}

data "aws_iam_policy_document" "iam_policy" {
  statement {
    resources = ["*"]
    actions = [
      "sts:AssumeRole",
      "ec2:RunInstances",
      "ec2:StartInstances",
      "ec2:CreateImage",
      "ec2:CopyImage",
      "ec2:ModifySnapshotAttribute",
      "ec2:CreateSecurityGroup",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:Describe*",
      "s3:PutObject",
      "s3:GetObject",
      "s3:PutObjectAcl",
      "logs:DescribeLogStreams",
      "logs:DescribeLogGroups",
      "logs:GetLogEvents",
      "logs:FilterLogEvents",
    ]
  }
}

resource "aws_iam_role_policy" "iam_policy" {
  name   = local.name
  role   = aws_iam_role.iam_role.name
  policy = data.aws_iam_policy_document.iam_policy.json
}

# Create instance profile to be attached to the ec2 instance used for testing
resource "aws_iam_instance_profile" "ec2" {
  name = local.name
  role = aws_iam_role.iam_role.name
}

# Attach the AmazonSSMManagedInstanceCore policy to allow EC2 access without SSH keys
resource "aws_iam_role_policy_attachment" "allow_ssm" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
