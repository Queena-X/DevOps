resource "aws_iam_policy" "e2_policy" {
  name        = "e2_policy"
  path        = "/"
  description = "Allows EC2 instances to call AWS services on your behalf."

  policy = file("s3-policy.json")
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = file("ec2-assume-policy.json")

  tags = {
    tag-key = "${var.env_code}-value"
  }
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.e2_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name
}


