variable "region" {
  description = "AWS Region for Deployment"
  type        = string
  default     = "us-east-2"
}

variable "cluster-launch-type" {
  description = "Launch Type of ECS Cluster"
  type        = string
  default     = "FARGATE"
}

variable "prod-port" {
  description = "Port on which ECS container listens."
  type        = number
  default     = 80
}

variable "cpu_architecture" {
  description = "CPU Architecture for the Task."
  type        = string
  default     = "X86_64"
}

variable "operating_system_family" {
  description = "OS Family for the Task."
  type        = string
  default     = "LINUX"
}

variable "prod-container-image" {
  type    = string
  default = "nginxdemos/hello"
}
