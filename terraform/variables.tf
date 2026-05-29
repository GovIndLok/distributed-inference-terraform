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

variable "HF_TOKEN" {
  description = "Hugging Face API token for model download"
  type        = string
  sensitive   = true
}