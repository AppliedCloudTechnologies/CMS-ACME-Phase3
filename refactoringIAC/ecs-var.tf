variable "cluster_launch_type" {
  description = "Launch Type of ECS Cluster"
  type        = string
  default     = "FARGATE"
}

variable "cpu_arch" {
  description = "CPU Architecture for the Task."
  type        = string
  default     = "X86_64"
}

variable "os_family" {
  description = "OS Family for the Task."
  type        = string
  default     = "LINUX"
}

variable "cont_image" {
  type    = string
  default = "ajitesh/springboot-web-app"
}
