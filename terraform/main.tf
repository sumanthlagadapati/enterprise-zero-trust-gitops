# VPC Module is defined in vpc/main.tf
# EKS Module is defined in eks/main.tf

# For simplicity in this monorepo structure, we are calling modules from the same root
# In a real enterprise setup, these would be separate state files or use Terragrunt

output "vpc_id_output" {
  value = module.vpc.vpc_id
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}
