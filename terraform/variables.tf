variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = "string"
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment (e.g., prod, staging)"
  type        = "string"
  default     = "prod"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = "string"
  default     = "fintech-platform-prod"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = "string"
  default     = "10.0.0.0/16"
}
