resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy  = file("ec2-assume-policy.json")
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]

  tags = {
    tag-key = "${var.env_code}-value"
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name
}


