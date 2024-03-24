locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Service      = var.Service
    Owner        = var.Owner
    CostCenter   = var.CostCenter
    Compliance   = var.Compliance

  }
}

#================= Creating the vpc ===================================================
resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.eks_vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true


  tags = merge(local.common_tags,
    {
      Name = "${var.project_name}-vpc-${terraform.workspace}"
    }
  )
}

#==================== Create igw and attach to the vpc=================================
resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = merge(local.common_tags,
    {
      Name = "${var.project_name}-igw-${terraform.workspace}"
    }
  )
}

#=========== use data source to get all avalablility zones in region===================
data "aws_availability_zones" "available_zones" {}

#===================create 2 public subnets============================================
resource "aws_subnet" "pubsn_web_az1" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.pubsn_web_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true


  tags = merge(local.common_tags,
    {
      Name = "${var.project_name}-pubsn_az1-${terraform.workspace}"
    }
  )
}

resource "aws_subnet" "pubsn_web_az2" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.pubsn_web_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true


  tags = merge(local.common_tags,
    {
      Name = "${var.project_name}-pubsn_az2-${terraform.workspace}"
    }
  )
}
#======================create public route table========================================

resource "aws_route_table" "pubrt_web" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }


  tags = merge(local.common_tags,
    {
      Name = "${var.project_name}-pubrt-${terraform.workspace}"
    }
  )
}

#===========associate public subnet public-subnet_az1 to "public route table==============
resource "aws_route_table_association" "pubsn_az1_web_association" {
  subnet_id      = aws_subnet.pubsn_web_az1.id
  route_table_id = aws_route_table.pubrt_web.id
}

#===========associate public subnet public-subnet_az2 to "public route table==============
resource "aws_route_table_association" "pubsn_az2_web_association" {
  subnet_id      = aws_subnet.pubsn_web_az2.id
  route_table_id = aws_route_table.pubrt_web.id
}

#===================create 2 private app subnets============================================
resource "aws_subnet" "privsn_app_az1" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.privsn_app_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false


  tags = merge(local.common_tags,
    {
      Name = "${var.project_name}-privsn_az1-${terraform.workspace}"
    }
  )
}

resource "aws_subnet" "privsn_app_az2" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.privsn_app_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = false


  tags = merge(local.common_tags,
    {
      Name = "${var.project_name}-privsn_app_az2-${terraform.workspace}"
    }
  )
}

#===================create 2 private db subnets============================================
resource "aws_subnet" "privsn_db_az1" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.privsn_db_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false


  tags = merge(local.common_tags,
    {
      Name = "${var.project_name}-privsn_db_az1-${terraform.workspace}"
    }
  )
}

resource "aws_subnet" "privsn_db_az2" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.privsn_db_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = false


  tags = merge(local.common_tags,
    {
      Name = "${var.project_name}-privsn_db_az2-${terraform.workspace}"
    }
  )
}

#======================create private route table for az1============================
resource "aws_route_table" "privrt_az1" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw_az1.id
  }


  tags = merge(local.common_tags,
    {
      Name = "${var.project_name}-privrt_az1-${terraform.workspace}"
    }
  )
}

#======================create private route table for az2============================
resource "aws_route_table" "privrt_az2" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw_az2.id
  }


  tags = merge(local.common_tags,
    {
      Name = "${var.project_name}-privrt_az2-${terraform.workspace}"
    }
  )
}

#===========associate private app subnets az1 to privsn_app_az1======================
resource "aws_route_table_association" "privsn_az1_app_association" {
  subnet_id      = aws_subnet.privsn_app_az1.id
  route_table_id = aws_route_table.privrt_az1.id
}

#===========associate private app subnets az2 to privsn_app_az2======================
resource "aws_route_table_association" "privsn_az2_app_association" {
  subnet_id      = aws_subnet.privsn_app_az2.id
  route_table_id = aws_route_table.privrt_az2.id
}

#==========================create EIP for nat-gateway-az1================================
resource "aws_eip" "eip_az1" {
  domain   = "vpc"
  
  tags = merge(local.common_tags,
    {
      "Name" = "${var.project_name}-eip-${terraform.workspace}"
    }
  )
}

#==========================create EIP for nat-gateway-az2================================
resource "aws_eip" "eip_az2" {
  domain   = "vpc"
  
  tags = merge(local.common_tags,
    {
      "Name" = "${var.project_name}-eip-${terraform.workspace}"
    }
  )
}

#===create two nat-gateways, one in each public subnet for high availability================
resource "aws_nat_gateway" "nat_gw_az1" {
  allocation_id = aws_eip.eip_az1.id
  subnet_id     = aws_subnet.pubsn_web_az1.id

  tags = merge(local.common_tags,
    {
      "Name" = "${var.project_name}-ngw_az1-${terraform.workspace}"
    }
   )
  }

  resource "aws_nat_gateway" "nat_gw_az2" {
  allocation_id = aws_eip.eip_az2.id
  subnet_id     = aws_subnet.pubsn_web_az2.id

  tags = merge(local.common_tags,
    {
      "Name" = "${var.project_name}-ngw_az2-${terraform.workspace}"
    }
   )
  }

  
