provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "us-east-1"

  user_data = templatefile("user_data.sh.tftpl", {
    github-bot-user     = var.github-bot-user
    your-github-token   = var.your-github-token
    webhook-secret       = var.webhook-secret
    github-repo         = var.github-repo
  })

  tags = {
    Name       = local.name
    Example    = local.name
  }
}

module "ec2_complete" {
  source = "../../modules/ec2"

  name = local.name

  ami                    = var.ami_id
  instance_type          = "t3.medium" # used to set core count below
  availability_zone      = element(module.vpc.azs, 0)
  subnet_id              = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids = [module.atlantis_sg.security_group_id]
  create_eip             = true
  disable_api_stop       = false

  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
  }

  # only one of these can be enabled at a time
  hibernation = true
  # enclave_options_enabled = true

  user_data_base64            = base64encode(local.user_data)
  user_data_replace_on_change = false

  cpu_options = {
    core_count       = 2
    threads_per_core = 1
  }
  enable_volume_tags = false
  root_block_device = {
    encrypted  = true
    type       = "gp3"
    throughput = 200
    size       = 50
    tags = {
      Name = "my-root-block"
    }
  }
}