# Terraform DevOps Pipeline

### ⚠️ Essential

1. Prepare an AWS account.
2. Prepare your own domain and get SSL Certificate of you domain issued by AWS Certificate Manager (ACM).
3. Prepare an IAM Role for ECS Task Execution.
4. Create your own **terraform.tfvars** on the root directory.
```
domain_name = [your domain name]
ssl_certificate = [ACM SSL Certificate ARN of your domain name]

jenkins_image = [Jenkins Image URI - ECR Image URI or DockerHub Image URI]
grafana_image = [Grafana Image URI - ECR Image URI or DockerHub Image URI]
prometheus_image = [Prometheus Image URI - ECR Image URI or DockerHub Image URI]
sonarqube_image = [SonarQube Image URI - ECR Image URI or DockerHub Image URI]
nexus_image = [Nexus Image URI - ECR Image URI or DockerHub Image URI]

ecs_task_execution_role_arn = [IAM Role for ECS Task Execution]
```
