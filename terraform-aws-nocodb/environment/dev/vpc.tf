module "vpc" {
  source                         = "../../modules/vpc"
  name                           = var.vpc_name
  cidr                           = var.cidr_block
  azs                            = var.azs
  private_subnets                = var.private_subnets
  public_subnets                 = var.public_subnets
  database_subnets               = var.database_subnets
  enable_nat_gateway             = var.enable_nat_gateway
  single_nat_gateway             = true
  enable_vpn_gateway             = var.enable_vpn_gateway
  create_database_subnet_group   = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}