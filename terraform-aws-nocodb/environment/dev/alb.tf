locals {
  name   = basename(path.cwd)

  vpc_cidr = var.cidr_block
  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-autoscaling"
    GithubOrg  = "terraform-aws-modules"
  }
}


module "alb" {
  source = "../../modules/alb"

  name    = var.alb_name
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  enable_deletion_protection = false

  security_group_ingress_rules = {
    http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "Allow HTTP traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"

      forward = {
        target_group_key = "default-target-group"
      }
    }
  }

  target_groups = {
    default-target-group = {
      name_prefix = "dev"
      protocol    = "HTTP"
      port        = 80
      target_type = "instance"

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        healthy_threshold   = 2
        unhealthy_threshold = 10
        timeout             = 20
        protocol            = "HTTP"
        matcher             = "200-399"
        port                = 80
      }
    }
  }

  tags = local.tags
}