module "webserver_sg" {
  source = "../../modules/sg"

  name        = var.webserver_sg_name
  description = var.webserver_sg_description
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    for rule in var.webserver_ingress_with_source_sg : {
      from_port              = rule.from_port
      to_port                = rule.to_port
      protocol               = rule.protocol
      description            = rule.description
      source_security_group_id = module.alb.security_group_id
    }
  ]

  egress_with_cidr_blocks = [
  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = var.webserver_egress_cidr_blocks
  }
  ]
}

module "rds_sg" {
  source = "../../modules/sg"

  name        = "rds_sg"
  description = "Security group for RDS allowing access from EC2 instances on port 5432"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port              = 5432
      to_port                = 5432
      protocol               = "tcp"
      description            = "Allow PostgreSQL from EC2"
      source_security_group_id = module.webserver_sg.security_group_id
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1" # Allow all outbound traffic
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "atlantis_sg" {
  source = "../../modules/sg"

  name        = var.atlantis_sg_name
  description = var.atlantis_sg_description
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    for rule in var.atlantis_ingress_with_cidr_blocks : {
      from_port              = rule.from_port
      to_port                = rule.to_port
      protocol               = rule.protocol
      description            = rule.description
      cidr_blocks            = var.cidr_blocks
    }
  ]

  egress_with_cidr_blocks = [
  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = var.webserver_egress_cidr_blocks
  }
  ]
}