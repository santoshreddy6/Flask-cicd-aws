output "ecr_repository_url" {
  description = "ECR repository URL to push Docker images"
  value       = aws_ecr_repository.app.repository_url
}

output "alb_dns_name" {
  description = "Public DNS of the Application Load Balancer"
  value       = "http://${aws_lb.app.dns_name}"
}

output "ecs_cluster_name" {
  description = "ECS Cluster name"
  value       = aws_ecs_cluster.main.name
}