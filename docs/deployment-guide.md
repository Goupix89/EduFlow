# EduFlow Deployment Guide

## Overview

This guide covers deploying EduFlow to production environments using Docker, Kubernetes, and cloud infrastructure.

## Prerequisites

- Docker and Docker Compose
- Kubernetes cluster (EKS, GKE, AKS, or self-hosted)
- AWS/GCP/Azure account for cloud resources
- Domain name and SSL certificate
- PostgreSQL database
- Redis instance

## Local Development Setup

### Using Docker Compose

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-org/eduflow.git
   cd eduflow
   ```

2. **Create environment file:**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

3. **Start services:**
   ```bash
   docker-compose up -d
   ```

4. **Run database migrations:**
   ```bash
   docker-compose exec backend npx prisma migrate deploy
   ```

5. **Seed database (optional):**
   ```bash
   docker-compose exec backend npx prisma db seed
   ```

### Manual Setup

1. **Install dependencies:**
   ```bash
   # Backend
   cd apps/backend
   npm install

   # Frontend
   cd ../frontend
   npm install
   ```

2. **Start PostgreSQL and Redis:**
   ```bash
   # Using Docker
   docker run -d --name postgres -p 5432:5432 -e POSTGRES_PASSWORD=password postgres:15
   docker run -d --name redis -p 6379:6379 redis:7-alpine
   ```

3. **Configure environment variables:**
   ```bash
   # Backend .env
   DATABASE_URL="postgresql://user:password@localhost:5432/eduflow"
   REDIS_URL="redis://localhost:6379"
   JWT_SECRET="your-secret-key"
   NODE_ENV="development"
   ```

4. **Run migrations:**
   ```bash
   cd apps/backend
   npx prisma migrate dev
   ```

5. **Start development servers:**
   ```bash
   # Backend
   npm run start:dev

   # Frontend
   cd ../frontend
   npm run dev
   ```

## Production Deployment

### Infrastructure Setup

#### 1. Cloud Provider Setup

**AWS Setup:**
```bash
# Create EKS cluster
eksctl create cluster -f infrastructure/k8s/cluster.yaml

# Create RDS PostgreSQL
aws rds create-db-instance \
  --db-instance-identifier eduflow-db \
  --db-instance-class db.t3.micro \
  --engine postgres \
  --master-username eduflow \
  --master-user-password your-password \
  --allocated-storage 20

# Create ElastiCache Redis
aws elasticache create-cache-cluster \
  --cache-cluster-id eduflow-redis \
  --cache-node-type cache.t3.micro \
  --engine redis \
  --num-cache-nodes 1
```

**GCP Setup:**
```bash
# Create GKE cluster
gcloud container clusters create eduflow-cluster \
  --num-nodes=3 \
  --zone=us-central1-a

# Create Cloud SQL PostgreSQL
gcloud sql instances create eduflow-db \
  --database-version=POSTGRES_15 \
  --tier=db-f1-micro \
  --region=us-central1

# Create Memorystore Redis
gcloud redis instances create eduflow-redis \
  --size=1 \
  --region=us-central1 \
  --zone=us-central1-a
```

#### 2. Domain and SSL

**Using Let's Encrypt:**
```bash
# Install cert-manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.yaml

# Create ClusterIssuer
kubectl apply -f infrastructure/k8s/cert-issuer.yaml

# Update ingress with TLS
kubectl apply -f infrastructure/k8s/ingress.yaml
```

### Application Deployment

#### 1. Build Docker Images

```bash
# Build backend
docker build -t your-registry/eduflow-backend:latest ./apps/backend

# Build frontend
docker build -t your-registry/eduflow-frontend:latest ./apps/frontend

# Push images
docker push your-registry/eduflow-backend:latest
docker push your-registry/eduflow-frontend:latest
```

#### 2. Deploy to Kubernetes

```bash
# Apply Kubernetes manifests
kubectl apply -f infrastructure/k8s/base/

# For production environment
kubectl apply -f infrastructure/k8s/overlays/production/
```

#### 3. Database Setup

```bash
# Run migrations
kubectl exec -it deployment/eduflow-backend -- npx prisma migrate deploy

# Seed database
kubectl exec -it deployment/eduflow-backend -- npx prisma db seed
```

### CI/CD Pipeline

#### GitHub Actions Setup

1. **Create secrets in GitHub:**
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `DOCKER_REGISTRY`
   - `KUBE_CONFIG`

2. **Push to trigger deployment:**
   ```bash
   git push origin main
   ```

#### Manual Deployment

```bash
# Build and deploy
npm run build
npm run deploy
```

### Environment Configuration

#### Production Environment Variables

```bash
# Database
DATABASE_URL="postgresql://user:password@host:5432/eduflow"

# Redis
REDIS_URL="redis://host:6379"

# JWT
JWT_SECRET="your-production-secret"
JWT_EXPIRES_IN="24h"

# API
NODE_ENV="production"
PORT="3001"
API_URL="https://api.eduflow.com"

# Frontend
NEXT_PUBLIC_API_URL="https://api.eduflow.com/api/v1"

# Email (optional)
SMTP_HOST="smtp.gmail.com"
SMTP_PORT="587"
SMTP_USER="your-email@gmail.com"
SMTP_PASS="your-app-password"

# File Storage (AWS S3)
AWS_S3_BUCKET="eduflow-files"
AWS_REGION="us-east-1"

# AI Services
OPENAI_API_KEY="your-openai-key"

# Monitoring
SENTRY_DSN="your-sentry-dsn"
```

### Monitoring and Observability

#### 1. Prometheus and Grafana

```bash
# Install Prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/prometheus

# Install Grafana
helm repo add grafana https://grafana.github.io/helm-charts
helm install grafana grafana/grafana
```

#### 2. Logging

```bash
# Install ELK stack
helm repo add elastic https://helm.elastic.co
helm install elasticsearch elastic/elasticsearch
helm install kibana elastic/kibana
helm install logstash elastic/logstash
```

#### 3. Application Monitoring

```bash
# Install Sentry for error tracking
npm install @sentry/nextjs @sentry/node
```

### Scaling

#### Horizontal Pod Autoscaling

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: eduflow-backend-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: eduflow-backend
  minReplicas: 3
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

#### Database Scaling

```bash
# Enable read replicas
aws rds create-db-instance-read-replica \
  --db-instance-identifier eduflow-db-replica \
  --source-db-instance-identifier eduflow-db
```

### Backup and Recovery

#### Database Backup

```bash
# Automated backup script
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
pg_dump -h $DB_HOST -U $DB_USER -d $DB_NAME > backup_$DATE.sql
aws s3 cp backup_$DATE.sql s3://eduflow-backups/
```

#### Disaster Recovery

1. **Regular backups** to S3/Cloud Storage
2. **Multi-region deployment** for high availability
3. **Automated failover** with health checks
4. **Data replication** across regions

### Security

#### Network Security

```yaml
# Network policies
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: eduflow-backend-policy
spec:
  podSelector:
    matchLabels:
      app: eduflow-backend
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: eduflow-frontend
```

#### Secrets Management

```bash
# Use AWS Secrets Manager or similar
kubectl create secret generic eduflow-secrets \
  --from-literal=database-url=$DATABASE_URL \
  --from-literal=redis-url=$REDIS_URL \
  --from-literal=jwt-secret=$JWT_SECRET
```

### Performance Optimization

#### CDN Setup

```bash
# CloudFront distribution for static assets
aws cloudfront create-distribution --distribution-config file://cloudfront-config.json
```

#### Caching Strategy

- **Browser caching** for static assets
- **Redis caching** for API responses
- **CDN caching** for media files
- **Database query caching** for frequently accessed data

### Troubleshooting

#### Common Issues

1. **Pod crashes:**
   ```bash
   kubectl logs deployment/eduflow-backend
   kubectl describe pod <pod-name>
   ```

2. **Database connection issues:**
   ```bash
   kubectl exec -it deployment/eduflow-backend -- nc -zv postgres 5432
   ```

3. **Memory/CPU issues:**
   ```bash
   kubectl top pods
   kubectl describe hpa eduflow-backend-hpa
   ```

#### Health Checks

```bash
# API health check
curl https://api.eduflow.com/health

# Database connectivity
kubectl exec -it deployment/eduflow-backend -- npx prisma db push --preview-feature
```

### Cost Optimization

1. **Right-size instances** based on usage
2. **Use spot instances** for non-critical workloads
3. **Implement auto-scaling** to match demand
4. **Monitor and optimize** resource usage
5. **Use reserved instances** for predictable workloads

### Maintenance

#### Regular Tasks

- **Update dependencies** monthly
- **Rotate secrets** quarterly
- **Review logs** weekly
- **Performance testing** before major releases
- **Backup verification** monthly

#### Zero-Downtime Deployment

```bash
# Rolling update
kubectl set image deployment/eduflow-backend eduflow-backend=your-registry/eduflow-backend:v2.0.0
kubectl rollout status deployment/eduflow-backend
```

For additional support, contact the DevOps team or refer to the [troubleshooting guide](troubleshooting.md).