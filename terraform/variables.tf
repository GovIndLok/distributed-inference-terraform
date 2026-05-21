variable "aws_region" {
  description = "AWS region for infrastructure deployment"
  type        = string
  default     = "ap-south-1"
}

variable "aws_profile" {
  description = "AWS cli profile name configured"
  type        = string
  default     = "default"
}

variable "project_name" {
  description = "AWS cli profile name configured"
  type        = string
  default     = "distributed-inference"
}

variable "environment" {
  description = "deployment environment"
  type        = string
  default     = "dev"
}
