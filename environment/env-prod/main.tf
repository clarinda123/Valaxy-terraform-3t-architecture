#create vpc
module "networking" {
  source = "./modules/networking"
  Service = var.Service
  Owner = var.Owner
  CostCenter = var.CostCenter
  Compliance = var.Compliance
  region_name = var.region_name
  project_name = var.project_name
  profile = var.profile
  eks_vpc_cidr = var.eks_vpc_cidr
  pubsn_web_az1_cidr = var.pubsn_web_az1_cidr
  pubsn_web_az2_cidr = var.pubsn_web_az2_cidr
  privsn_app_az1_cidr =var.privsn_app_az1_cidr
  privsn_app_az2_cidr =var.privsn_app_az2_cidr
  privsn_db_az1_cidr = var.privsn_db_az1_cidr
  privsn_db_az2_cidr = var.privsn_db_az2_cidr
}

module "eks-cluster" {
  source = "./modules/eks-cluster"
  project_name = var.project_name
  pubsn_web_az1_cidr = var.pubsn_web_az1_cidr
  pubsn_web_az2_cidr = var.pubsn_web_az2_cidr
  privsn_app_az1_cidr = var.privsn_app_az1_cidr
  privsn_app_az2_cidr = var.privsn_app_az2_cidr
  desired_size = var.desired_size
  min_size = var.min_size
  max_size = var.max_size
  instance_types = var.instance_types
  max_unavailable = var.max_unavailable
}
