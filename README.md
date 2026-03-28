# 🚀 End-to-End CI/CD Pipeline on AWS

A beginner-friendly DevOps project that automatically builds, pushes, and deploys a containerized Flask API to AWS ECS Fargate — triggered by a simple `git push`.

---

## 🛠️ Tech Stack

| Tool | Purpose |
|---|---|
| Python Flask | Minimal REST API |
| Docker | Containerize the app |
| AWS ECR | Store Docker images |
| AWS ECS Fargate | Run containers (serverless) |
| AWS ALB | Public-facing load balancer |
| AWS VPC | Network isolation |
| Terraform | Infrastructure as Code |
| GitHub Actions | CI/CD automation |

---

## 🏗️ Architecture

```
Developer
    |
    | git push to main
    v
GitHub Actions
    |
    |-- Job 1: Build & Push ─────────────────────────────┐
    |       |                                             |
    |   Docker Build                               AWS ECR
    |   (tagged with git SHA)              (image stored here)
    |       |                                             |
    |-- Job 2: Deploy (runs after Job 1) ────────────────┘
            |
        Terraform Apply
            |
            |-- VPC + Subnets
            |-- Security Groups
            |-- Application Load Balancer
            |-- ECS Cluster + Task Definition
            |-- ECS Fargate Service
            |
            v
    Live Flask API
    http://<alb-dns>.us-east-1.elb.amazonaws.com
```

---

## 📁 Project Structure

```
flask-cicd-aws/
├── app/
│   ├── app.py                  # Flask API with /health and /hello endpoints
│   └── requirements.txt        # Python dependencies
├── Dockerfile                  # Containerizes the Flask app
├── terraform/
│   ├── main.tf                 # AWS provider, VPC, ECR, networking
│   ├── ecs.tf                  # ECS cluster, service, ALB, IAM roles
│   ├── variables.tf            # Input variables
│   └── outputs.tf              # Output values (ALB URL, ECR URL)
└── .github/
    └── workflows/
        └── deploy.yml          # GitHub Actions CI/CD pipeline
```

---

## ⚙️ How the Pipeline Works

1. You push code to the `main` branch
2. GitHub Actions automatically triggers the pipeline
3. **Job 1 — Build & Push:**
   - Builds a Docker image from the `Dockerfile`
   - Tags it with the git commit SHA (unique per commit)
   - Pushes it to AWS ECR (private image registry)
4. **Job 2 — Deploy:**
   - Runs `terraform apply` to provision/update AWS infrastructure
   - ECS Fargate pulls the new image and deploys it
   - App becomes accessible via the ALB public URL

---

## 🚦 API Endpoints

| Endpoint | Method | Response |
|---|---|---|
| `/health` | GET | `{"status": "healthy"}` |
| `/hello` | GET | `{"message": "Hello from CI/CD pipeline!", "env": "production"}` |

---

## 💡 Key Design Decisions

**Why ECS Fargate over EC2?**
Fargate is serverless — no need to manage or patch EC2 instances. It's simpler and reduces operational overhead for small projects.

**Why tag Docker images with git SHA?**
Every image maps to an exact commit. This makes deployments immutable and fully traceable — you always know exactly what code is running.

**Why Terraform remote state in S3?**
State is stored remotely so it's never lost locally, can be shared across machines, and supports state locking for team collaboration.

**Why gunicorn instead of Flask's built-in server?**
Flask's dev server is not production-safe. Gunicorn is a production-grade WSGI server that handles multiple concurrent requests properly.

---

## 🧹 Cleanup (avoid AWS charges)

When you're done, destroy all AWS resources:
```bash
cd terraform
terraform destroy -var="ecr_image_url=placeholder"
```

---

## 👨‍💻 Author

**U Santosh Reddy**
B.Tech CSE — DevOps / Cloud Engineer
