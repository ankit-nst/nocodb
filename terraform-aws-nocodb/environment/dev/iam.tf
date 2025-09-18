module "iam_role_ec2_secretsmanager" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"

  name = "ec2-secrets-access"

  trust_policy_permissions = {
    EC2AssumeRole = {
      actions = [
        "sts:AssumeRole",
      ]
      principals = [{
        type        = "Service"
        identifiers = ["ec2.amazonaws.com"]
      }]
      condition = []
    }
  }

  policies = {
    SecretsManagerAccess = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
    # You can define additional policies if needed
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
