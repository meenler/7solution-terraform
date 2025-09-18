# 🌐 Terraform GKE Autopilot on GCP

Infrastructure as Code (IaC) for provisioning **Google Kubernetes Engine (GKE Autopilot)** on GCP,  
including Network, NAT, and IAM configuration using **Terraform modules**.

---

## 📂 Project Structure

```
.
├── envs/               # Environment-specific configuration
│   ├── dev/            # Development environment
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   ├── terraform.tfvars
│   │   ├── variables.tf
│   │   └── versions.tf
│   └── prod/           # Production environment
│       ├── backend.tf
│       ├── main.tf
│       ├── outputs.tf
│       ├── providers.tf
│       ├── terraform.tfvars
│       ├── variables.tf
│       └── versions.tf
├── global/             # (Optional) Global resources (DNS, org IAM, etc.)
├── modules/            # Reusable Terraform modules
│   ├── gke_standard/
│   ├── iam/
│   ├── nat/
│   └── network/
└── README.md
```

---

## 🚀 Getting Started

### 1. Install Terraform
Refer to the [Terraform installation guide](https://developer.hashicorp.com/terraform/downloads).  
Ensure the installed version matches the requirements in `versions.tf`.

```bash
terraform -version
```

---

### 2. Initialize Terraform
Navigate to the target environment, e.g., `dev`:

```bash
cd envs/dev
terraform init
```

---

### 3. Review the Execution Plan
Generate and review the plan to verify the resources to be created:

```bash
terraform plan -var-file=terraform.tfvars
```

---

### 4. Apply the Configuration
Provision the infrastructure:

```bash
terraform apply -var-file=terraform.tfvars
```

---

### 5. Destroy the Infrastructure
To remove all resources created by this configuration:

```bash
terraform destroy -var-file=terraform.tfvars
```

---

## 🔑 Remote State
Terraform state files are stored in **Google Cloud Storage (GCS)**:

- Bucket: `7solution-bucket-472509`
- Path: `/terraform/dev/` or `/terraform/prod/`

---

## ⚠️ Git Ignore
The following files should **never be committed** to version control (already covered in `.gitignore`):

- `.terraform/`
- `*.tfstate`, `*.tfstate.*`
- `*.tfvars` (may contain sensitive information)
- `*.tfplan`

---

## 👨‍💻 Useful Commands

```bash
# Format code consistently
terraform fmt -recursive

# Validate configuration syntax
terraform validate

# List all resources tracked in the state
terraform state list

# credentials to connect Kubernetes cluster
gcloud container clusters get-credentials <CLUSTER_NAME> \
  --region <REGION> \
  --project <PROJECT_ID>
```

---

## 📌 Notes
- Only `.tf` files and `.tfvars.example` files should be committed.  
- Actual `.tfvars` files must remain local and excluded from version control as they may contain secrets.  
- Workspaces (`terraform workspace`) can be used if multiple environments are managed within the same directory.  

---

## 📜 License

