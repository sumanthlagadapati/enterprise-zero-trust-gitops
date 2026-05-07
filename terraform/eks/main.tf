module "eks" {
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
      min_size     = 2
      max_size     = 5
      desired_size = 2

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
    Environment = var.environment
    Architecture = "ZeroTrust"
  }
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}
