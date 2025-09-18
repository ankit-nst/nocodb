# VPC Variables
vpc_name       = "dev-vpc"
cidr_block     = "10.0.0.0/16"
azs            = ["us-east-1a", "us-east-1b", "us-east-1c"]
private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
database_subnets = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24"]
enable_nat_gateway = true
enable_vpn_gateway = false
tags = {
  Environment = "dev"
  Project     = "nocodb"
}



# ALB Variables
alb_name = "nocodb-alb" # Replace with your VPC ID
alb_ingress_cidr_blocks = "0.0.0.0/0"
alb_egress_cidr_blocks  = "0.0.0.0/0"
alb_ingress_ports = [
  { from_port = 80, to_port = 80, protocol = "tcp" },
  { from_port = 443, to_port = 443, protocol = "tcp" }
]



# Webserver Security Group Variables
webserver_sg_name        = "nocodb_webserver_sg"
webserver_sg_description = "Security group for nocodb webserver"
webserver_ingress_cidr_blocks = "10.10.0.0/16"
webserver_egress_cidr_blocks  = "0.0.0.0/0"

webserver_ingress_with_source_sg = [
  {
    from_port              = 8080
    to_port                = 8080
    protocol               = "tcp"
    description            = "nocodb_webserver port"
    source_security_group_id = "sg-12345678" # Replace with ALB security group ID
  },
  {
    from_port              = 80
    to_port                = 80
    protocol               = "tcp"
    description            = "nocodb_webserver ping port"
    source_security_group_id = "sg-12345678" # Replace with ALB security group ID
  }
]


# atlantis Security Group Variables
atlantis_sg_name        = "nocodb_atlantis_sg"
atlantis_sg_description = "Security group for nocodb atlantis"
atlantis_ingress_cidr_blocks = "10.10.0.0/16"
atlantis_egress_cidr_blocks  = "0.0.0.0/0"

atlantis_ingress_with_cidr_blocks = [
  {
    from_port              = 4141
    to_port                = 4141
    protocol               = "tcp"
    description            = "nocodb_atlantis port"
    cidr_blocks            = "0.0.0.0/0" 
  },
  {
    from_port              = 80
    to_port                = 80
    protocol               = "tcp"
    description            = "nocodb_atlantis ping port"
    cidr_blocks            = "0.0.0.0/0" 
  }
]




# ASG Variables
asg_name             = "nocodb-asg"
launch_template_name = "nocodb-launch-template"
iam_role_name        = "nocodb-ec2-role"
ami_id               = "ami-0e95a5e2743ec9ec9"
instance_type        = "t3.micro"
instance_name        = "dev-nocodb"



# RDS Variables
db_name = "db-dev-nocodb"


# Atlantis EC2 Variables
github_bot_user   = "ankit-nst"
your_github_token = "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"
webhook_secret    = "abcd1234"
github_repo       = "github.com/ankit-nst/nocodb"