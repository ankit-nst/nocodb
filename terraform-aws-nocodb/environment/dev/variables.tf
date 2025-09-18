//vpc variables
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "database_subnets" {
  description = "List of database subnet CIDRs"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway"
  type        = bool
  default     = true
}

variable "enable_vpn_gateway" {
  description = "Enable VPN Gateway"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

// alb variables

variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
  default     = "nocodb-alb"
}

variable "alb_ingress_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the ALB"
  type        = string
  default     = "0.0.0.0/0" # Open to all by default
}

variable "alb_ingress_ports" {
  description = "List of ingress ports for the ALB"
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
  }))
  default = [
    { from_port = 80, to_port = 80, protocol = "tcp" },
    { from_port = 443, to_port = 443, protocol = "tcp" }
  ]
}

variable "alb_egress_cidr_blocks" {
  description = "List of CIDR blocks for outbound traffic"
  type        = string
  default     = "0.0.0.0/0"
}


// webserver security group

variable "webserver_sg_name" {
  description = "Name of the webserver security group"
  type        = string
  default     = "nocodb_webserver_sg"
}

variable "webserver_sg_description" {
  description = "Description of the webserver security group"
  type        = string
  default     = "Security group for nocodb_webserver_sg with custom ports open within VPC, and PostgreSQL publicly open"
}

variable "webserver_ingress_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the webserver"
  type        = string
  default     = "10.10.0.0/16"
}


variable "webserver_ingress_with_source_sg" {
  description = "List of ingress rules with source security group for the webserver"
  type        = list(object({
    from_port              = number
    to_port                = number
    protocol               = string
    description            = string
    source_security_group_id = string
  }))
  default = [
    {
      from_port              = 8080
      to_port                = 8080
      protocol               = "tcp"
      description            = "nocodb_webserver port"
      source_security_group_id = "module.alb_sg.security_group_id"
    },
    {
      from_port              = 80
      to_port                = 80
      protocol               = "tcp"
      description            = "nocodb_webserver ping port"
      source_security_group_id = "module.alb_sg.security_group_id"
    }
  ]
}

variable "webserver_egress_cidr_blocks" {
  description = "CIDR block for webserver egress traffic"
  type        = string
  default     = "0.0.0.0/0"
}

variable "atlantis_sg_name" {
  description = "Name of the Atlantis security group"
  type        = string
  default     = "nocodb_atlantis_sg"
}

variable "atlantis_sg_description" {
  description = "Description of the Atlantis security group"
  type        = string
  default     = "Security group for nocodb atlantis"
}

variable "atlantis_ingress_cidr_blocks" {
  description = "CIDR blocks allowed to access Atlantis"
  type        = string
  default     = "10.10.0.0/16"
}

variable "atlantis_egress_cidr_blocks" {
  description = "CIDR blocks for Atlantis egress traffic"
  type        = string
  default     = "0.0.0.0/0"
}

variable "atlantis_ingress_with_cidr_blocks" {
  description = "List of ingress rules with CIDR blocks for Atlantis"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
    cidr_blocks = string
  }))
  default = [
    {
      from_port   = 4141
      to_port     = 4141
      protocol    = "tcp"
      description = "nocodb_atlantis port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "nocodb_atlantis ping port"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

// ASG variable
variable "asg_name" {
  description = "Name of the Auto Scaling Group"
  type        = string
  default     = "nocodb-asg"
}

variable "launch_template_name" {
  description = "Name of the launch template"
  type        = string
  default     = "nocodb-launch-template"
}

variable "iam_role_name" {
  description = "Name of the IAM role for the EC2 instances"
  type        = string
  default     = "nocodb-ec2-role"
}
variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default     = "ami-09b6c6baae595a21c" # Replace with your AMI ID
}

variable "aws_region" {
  description = "AMI region for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
  default     = "t3.micro"
}


variable "instance_name" {
  description = "Instance name for the EC2 instances"
  type        = string
  default     = "dev-nocodb"
}



//DB
variable "db_name" {
  description = "DB  name for the rds instances"
  type        = string
  default     = "db-dev-nocodb"
}



variable "enabled_cloudwatch_logs_exports" {
  description = "Determines whether a CloudWatch log are exported"
  type        = bool
  default     = true
}

variable "create_cloudwatch_log_group" {
  description = "Determines whether a CloudWatch log group is created for each `enabled_cloudwatch_logs_exports`"
  type        = bool
  default     = true
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "The number of days to retain CloudWatch logs for the DB instance"
  type        = number
  default     = 2
}

variable "cloudwatch_log_group_kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data"
  type        = string
  default     = null
}

variable "cloudwatch_log_group_skip_destroy" {
  description = "Set to true if you do not wish the log group (and any logs it may contain) to be deleted at destroy time, and instead just remove the log group from the Terraform state"
  type        = bool
  default     = false
}

variable "cloudwatch_log_group_class" {
  description = "Specified the log class of the log group. Possible values are: STANDARD or INFREQUENT_ACCESS"
  type        = string
  default     = "STANDARD"
}

variable "cloudwatch_log_group_tags" {
  description = "Additional tags for the CloudWatch log group(s)"
  type        = map(string)
  default     = {}
}


// atlantis-ec2 variables

variable "github-bot-user" {
  description = "GitHub bot user for Atlantis"
  type        = string
}

variable "your-github-token" {
  description = "GitHub token for Atlantis"
  type        = string
  sensitive   = true
}

variable "webhook-secret" {
  description = "GitHub webhook secret for Atlantis"
  type        = string
  sensitive   = true
}

variable "github-repo" {
  description = "GitHub repository for Atlantis"
  type        = string
}