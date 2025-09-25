terraform {
  backend "s3" {
    bucket = "my-state-lock-bucket-for-innovatemart"
    region = "us-east-1"
    key = "innovatemart/s3/terraform.tfstate"
  }
#    required_providers {
#     aws = {
#       source = "hashicorp/aws"
#       version = "6.13.0"
#     }
#   }
}

provider "aws" {
  region = "us-east-1"
}



provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    command     = "aws"
  }
}


provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}
