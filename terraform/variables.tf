variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "Application name used for naming resources"
  type        = string
  default     = "flask-cicd-app"
}

variable "ecr_image_url" {
  description = "Full ECR image URL (set by GitHub Actions during deploy)"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "production"
}