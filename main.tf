#create vpc
module "networking" {
  source              = "./modules/networking"
  Service             = var.Service
  Owner               = var.Owner
  CostCenter          = var.CostCenter
  Compliance          = var.Compliance
  region_name         = var.region_name
  project_name        = var.project_name
  profile             = var.profile
  eks_vpc_cidr        = var.eks_vpc_cidr
  pubsn_web_az1_cidr  = var.pubsn_web_az1_cidr
  pubsn_web_az2_cidr  = var.pubsn_web_az2_cidr
  privsn_app_az1_cidr = var.privsn_app_az1_cidr
  privsn_app_az2_cidr = var.privsn_app_az2_cidr
  privsn_db_az1_cidr  = var.privsn_db_az1_cidr
  privsn_db_az2_cidr  = var.privsn_db_az2_cidr
}
