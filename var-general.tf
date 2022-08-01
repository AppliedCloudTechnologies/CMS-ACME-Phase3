variable "cidr_block" {
  description = "Main CIDR Block of the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public-subnet" {
  type    = string
  default = "10.0.1.0/24"
}

variable "public-subnet2" {
  type    = string
  default = "10.0.2.0/24"
}
