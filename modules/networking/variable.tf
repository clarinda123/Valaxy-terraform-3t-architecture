variable "Service" {
  type        = string
  description = "The type of service provided to the client"
  default     = "Infra"
}

variable "Owner" {
  type        = string
  description = "The owner of all the resources to be built"
  default     = "Customer-Application-a"

}

variable "CostCenter" {
  type        = string
  description = "The cost center to be applied to the resources"
  default     = "1.0.0.1"

}

variable "Compliance" {
  type        = string
  description = "The compliance status of the resources"
  default     = "FCA"

}

variable "region_name" {
  type        = string
  description = "The region for resources creation"
  default     = "eu-west-2"

}

variable "project_name" {
  type        = string
  description = "The project name for resources creation"
  default     = "valaxy3t"
}

variable "profile" {
  type        = string
  description = "The profile for resources creation"
  default     = "Clarinda"

}

variable "eks_vpc_cidr" {
  type        = string
  description = "The cidr block for the vpc"
  default     = "10.0.0.0/16"

}

variable "pubsn_web_az1_cidr" {
  type        = string
  description = "The cidr block for public subnet az1"
  default     = "10.0.0.0/24"

}

variable "pubsn_web_az2_cidr" {
  type        = string
  description = "The cidr block for public subnet az2"
  default     = "10.0.1.0/24"

}

variable "privsn_app_az1_cidr" {
  type        = string
  description = "The cidr block for private app subnet az1"
  default     = "10.0.2.0/24"

}

variable "privsn_app_az2_cidr" {
  type        = string
  description = "The cidr block for private app subnet az2"
  default     = "10.0.3.0/24"

}

variable "privsn_db_az1_cidr" {
  type        = string
  description = "The cidr block for private database subnet az1"
  default     = "10.0.4.0/24"

}

variable "privsn_db_az2_cidr" {
  type        = string
  description = "The cidr block for private database subnet az2"
  default     = "10.0.5.0/24"

}



