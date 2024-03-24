variable "Service" {
  type        = string
  description = "The type of service provided to the client"
}

variable "Owner" {
  type        = string
  description = "The owner of all the resources to be built"
}

variable "CostCenter" {
  type        = string
  description = "The cost center to be applied to the resources"
}

variable "Compliance" {
  type        = string
  description = "The compliance status of the resources"
}

variable "region_name" {
  type        = string
  description = "The region for resources creation"
}

variable "project_name" {
  type        = string
  description = "The project name for resources creation"
}

variable "profile" {
  type        = string
  description = "The profile for resources creation"
}

variable "eks_vpc_cidr" {
  type        = string
  description = "The cidr block for the vpc"
}

variable "pubsn_web_az1_cidr" {
  type        = string
  description = "The cidr block for public subnet az1"
}

variable "pubsn_web_az2_cidr" {
  type        = string
  description = "The cidr block for public subnet az2"
}

variable "privsn_app_az1_cidr" {
  type        = string
  description = "The cidr block for private app subnet az1"
}

variable "privsn_app_az2_cidr" {
  type        = string
  description = "The cidr block for private app subnet az2"
}

variable "privsn_db_az1_cidr" {
  type        = string
  description = "The cidr block for private database subnet az1"
}

variable "privsn_db_az2_cidr" {
  type        = string
  description = "The cidr block for private database subnet az2"
}




