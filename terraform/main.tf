################################################################################
# VPC Module
################################################################################

module "vpc" {
  # checkov:skip=CKV_TF_1: Using official Terraform Registry versioning for stability and ease of maintenance
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.environment}-main-vpc"
  cidr = var.vpc_cidr

  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = var.environment != "prod"
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }

  tags = {
    Type = "Networking"
  }
}

################################################################################
# EKS Module
################################################################################

module "eks" {
  # checkov:skip=CKV_TF_1: Using official Terraform Registry versioning for stability and ease of maintenance
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  cluster_endpoint_public_access  = true # Restricted via SG in production
  cluster_endpoint_private_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  eks_managed_node_groups = {
    general = {
      instance_types = ["t3.medium"]
      min_size       = 2
      max_size       = 5
      desired_size   = 2

      # Use Bottlerocket for enhanced security
      ami_type = "BOTTLEROCKET_x86_64"
    }
  }

  # Cluster encryption
  create_kms_key = true
  cluster_encryption_config = {
    resources = ["secrets"]
  }

  tags = {
    Environment  = var.environment
    Architecture = "ZeroTrust"
  }
}

################################################################################
# Outputs
################################################################################

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}
