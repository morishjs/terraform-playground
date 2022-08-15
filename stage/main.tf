provider "aws" {
  region = "ap-northeast-2"
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
  }
}

module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  version      = "18.27.1"
  cluster_name = "example"
  vpc_id       = "vpc-0c8bc8c4907aeb19c"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  subnet_ids   = [
    "subnet-01dd98c0c226c799a", "subnet-0de1853beec56a5ab", "subnet-0710f280083883851", "subnet-0a9a6c190ddb7167e"
  ]
  eks_managed_node_group_defaults = {
    disk_size      = 20
    instance_types = ["t3.small"]
    ami_type       = "AL2_x86_64"
  }
  eks_managed_node_groups = {
    test = {
      min_size     = 1
      max_size     = 1
      desired_size = 1
    }
  }
}
