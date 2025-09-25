module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.3.1"

  name               = var.cluster_name
  kubernetes_version = "1.33"
  endpoint_public_access = true
  enable_irsa = true
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets

  addons = {
    coredns                = {
        before_compute = true
    }

    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {}
    vpc-cni                = {
      before_compute = true
    }
    aws-ebs-csi-driver     = {
        most_recent = true
    }
  }

  iam_role_additional_policies = {
    AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"

  }



  eks_managed_node_groups = {
    innovatemart-nodegroup = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 3
      desired_size   = 2
      iam_role_additional_policies = {
        AmazonEKSWorkerNodePolicy          = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
        AmazonEKS_CNI_Policy               = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        AmazonSSMManagedInstanceCore       = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
    }
  }

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Name = var.cluster_name
    Environment = "dev"
    Terraform   = "production"
  }

access_entries = {
    admin_user = {
        kubernetes_groups = []
      principal_arn = "arn:aws:iam::686255950557:user/Adewumi"

      policy_associations = {
        admin_policy = {
          policy_arn =  "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
      }
    }
    dev-innocent = {
        kubernetes_groups = []
      principal_arn = "arn:aws:iam::686255950557:user/dev-innocent"

      policy_associations = {
        view = {
          policy_arn =  "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminViewPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
      }

      }
    }
}
