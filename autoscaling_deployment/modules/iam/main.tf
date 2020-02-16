resource "aws_iam_role" "nginx_codedeploy_svc_role" {
  name = "nginx_codedeploy_service_role"

  assume_role_policy = file("${path.module}/json/CodeDeploy-Trust.json")

  tags = {
    Name = "nginx_codedeploy_service_role"
  }
}

resource "aws_iam_role_policy_attachment" "nginx_aws_codedeploy_role_attach" {
  role       = aws_iam_role.nginx_codedeploy_svc_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_iam_role" "nginx_ec2_instance_role" {
  name = "nginx_ec2_instance_role"

  assume_role_policy = file("${path.module}/json/CodeDeploy-EC2-Trust.json")

  tags = {
    Name = "nginx_ec2_instance_role"
  }
}

resource "aws_iam_policy" "nginx_codedeploy_ec2_permissions_policy" {
  name        = "nginx_codedeploy_ec2_permissions_policy"
  description = "nginx_codedeploy_ec2_permissions_policy"
  policy      = file("${path.module}/json/CodeDeploy-EC2-Permissions.json")
}

resource "aws_iam_role_policy_attachment" "nginx_codedeploy_ec2_permissions_policy_attach" {
  role       = aws_iam_role.nginx_codedeploy_svc_role.name
  policy_arn = aws_iam_policy.nginx_codedeploy_ec2_permissions_policy.arn
}

resource "aws_iam_instance_profile" "nginx_ec2_instance_profile" {
  name = "nginx_ec2_instance_profile"
  role = aws_iam_role.nginx_ec2_instance_role.arn
}

