# Intentionally misconfigured for demo purposes. DO NOT DEPLOY.
terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

# Mock credentials so `terraform plan` runs in CI without a real AWS account
provider "aws" {
  region                      = "eu-west-2"
  access_key                  = "mock"
  secret_key                  = "mock"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
}

variable "enable_encryption" {
  type    = bool
  default = false # only visible as a problem once resolved -> good plan-scan talking point
}

resource "aws_s3_bucket" "data" {
  bucket = "aqua-demo-customer-data"
}

resource "aws_s3_bucket_public_access_block" "data" {
  bucket                  = aws_s3_bucket.data.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_security_group" "ssh_open" {
  name        = "demo-open-ssh"
  description = "Wide open SSH"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ebs_volume" "data" {
  availability_zone = "eu-west-2a"
  size              = 20
  encrypted         = var.enable_encryption
}
