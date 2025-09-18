terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 6.0"
        }
    }

    backend "s3" {
        bucket         = "dev-terraform-state-1757961509"
        key            = "global/s3/terraform.tfstate"
        region         = "ap-southeast-1"
        dynamodb_table = "dev-terraform-lock-table-1757961509"
        encrypt        = true
    }
}

provider "aws" {
    region = var.aws_region
    profile = "sso-ankit-personal"
}