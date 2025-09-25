module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"

  name = "eks-vpc"
  cidr = var.cidr
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  enable_nat_gateway = true
  enable_dns_hostnames = true
  single_nat_gateway = true
  enable_dns_support   = true
  tags = {

    Terraform = "true"
    Environment = "dev"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  public_subnet_tags = {
     "kubernetes.io/cluster/${var.cluster_name}" = "shared"
     "kubernetes.io/role/elb"                      = "1"
   }

   private_subnet_tags = {
     "kubernetes.io/cluster/${var.cluster_name}" = "shared"
     "kubernetes.io/role/internal-elb"             = "1"
   }
 }
