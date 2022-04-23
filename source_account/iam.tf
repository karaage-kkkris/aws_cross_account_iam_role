resource "aws_iam_role" "cw_role" {
  name                 = "${local.name}-cw-source-role"
  permissions_boundary = var.permissions_boundary
  assume_role_policy   = data.aws_iam_policy_document.cw_trust.json
}

data "aws_iam_policy_document" "cw_trust" {

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.role_arns
    }
  }
}

resource "aws_iam_role_policy_attachment" "cw_access" {
  role       = aws_iam_role.cw_role.id
  policy_arn = aws_iam_policy.cw_access.arn
}

# Define IAM policy document and policy to be attached to the testing role
data "aws_iam_policy_document" "cw_access" {

  statement {
    actions = [
      "logs:DescribeLogStreams",
      "logs:DescribeLogGroups",
      "logs:GetLogEvents",
      "logs:FilterLogEvents",
    ]

    resources = [var.cw_arn]
  }
}

resource "aws_iam_policy" "cw_access" {
  name        = "${local.name}-cw"
  description = "CloudWatch log group access policy"
  policy      = data.aws_iam_policy_document.cw_access.json
}
