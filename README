# **InnovateMart EKS Deployment**

## **Architecture Overview**

I deployed InnovateMart's retail store sample application on **Amazon EKS** using **Terraform** for Infrastructure as Code and **GitHub Actions** for CI/CD automation.

**Core Components:**

* **VPC**: Custom VPC (`10.0.0.0/16`) with public/private subnets across 3 Availability Zones (`us-east-1a/b/c`).
* **EKS Cluster**: `"innovatemart"` cluster (v1.33) with managed node group (`t3.medium` instances).
* **Add-ons**: CoreDNS, VPC CNI, kube-proxy, EBS CSI Driver, EKS Pod Identity Agent.
* **Storage**: S3 backend (`my-state-lock-bucket-for-innovatemart`) for Terraform state management.
* **IAM**: Developer IAM user `dev-innocent` with read-only access to the EKS cluster.

![EKS Cluster Overview](./screenshots/eks-cluster-overview.png)


---

## **Deployment Process**

### **1. Infrastructure Provisioning (Terraform)**

I used Terraform modules to define and deploy the infrastructure.

```bash
terraform init -reconfigure
terraform plan
terraform apply -auto-approve
```

**Key Files:**

* `eks-vpc.tf` → VPC with proper subnet tagging for EKS.
* `eks-cluster.tf` → EKS cluster definition with IAM access entries.
* `iam.tf` → IAM user (`dev-innocent`) and attached policies.
* `providers.tf` → S3 backend configuration for state locking.

![vpc Overview](./screenshots/vpc-overwiew.png)

---

### **2. Application Deployment (Kubernetes)**

After infrastructure was ready, I deployed the InnovateMart **retail store microservices** using `kubectl` with the official manifest:

```bash
aws eks update-kubeconfig --name innovatemart --region us-east-1
kubectl apply -f https://github.com/aws-containers/retail-store-sample-app/releases/latest/download/kubernetes.yaml
kubectl wait --for=condition=available deployments --all
```

**Application Access**:
The retail store UI is accessible via the LoadBalancer service.

URL:

```
http://a823880c086ea47beb2b5466390b2365-2041068971.us-east-1.elb.amazonaws.com
```

![Successful services running](./screenshots/kubectl-get-pods.png)
![Retail store ui](./screenshots/retail-ui.png)

---

## **CI/CD Pipeline**

GitHub Actions workflow (`.github/workflows/workflow.yml`) automates deployment:

* **Feature branches** → run `terraform plan` for validation.
* **Main branch** → run `terraform apply` and deploy workloads.
* **Security** → AWS credentials stored securely as GitHub secrets.

![Successful github action workflow](./screenshots/successful-github-action-workflow.png)

---

## **Developer Access**

**IAM User**: `dev-innocent`

* **Policy**: `AmazonEKSAdminViewPolicy` with namespace-level access to `default`.
* **Setup Instructions**:

```bash
aws configure --profile dev-innocent
# Use provided access key/secret
aws eks update-kubeconfig --name innovatemart --region us-east-1 --profile dev-innocent
kubectl get pods
```

**Developer Credentials (to be shared separately):**

* Username: `dev-innocent`
* Access Key ID: [Provided separately]
* Secret Access Key: [Provided separately]
* Password: Auto-generated.

![IAM user](./screenshots/dev-innocent.png)

**Verification Commands:**

```bash
kubectl get nodes
kubectl get pods -A
kubectl get svc
```

---

✅ The infrastructure successfully supports InnovateMart’s microservices application with security, scalability, and automation foundations in place.

---

