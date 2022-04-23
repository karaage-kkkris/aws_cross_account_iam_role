output "ec2_id" {
  value = aws_instance.ec2.id
}

output "role" {
  value = aws_iam_role.iam_role
}
