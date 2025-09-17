# Terraform GKE on GCP (Singapore, Low-Cost Autopilot) — Split Services & Envs

This repo gives a mid-level, production-friendly layout:
- Split services: **network**, **nat**, **gke_autopilot**, **iam**
- Split environments: **envs/dev** and **envs/prod**
- Region: **asia-southeast1 (Singapore)**
- Cheapest server spec: **GKE Autopilot** (pay per Pod; no nodes to manage)

## Prereqs
- Install gcloud & Terraform (>= 1.5)
- Enable APIs (once):
  ```bash
  gcloud services enable compute.googleapis.com container.googleapis.com iam.googleapis.com
  ```
- Create a GCS bucket for remote state (once):
  ```bash
  gcloud storage buckets create gs://YOUR_TFSTATE_BUCKET --location=ASIA --uniform-bucket-level-access
  ```

## Configure
- Edit `envs/dev/terraform.tfvars` and `envs/prod/terraform.tfvars`:
  ```hcl
  project_id       = "YOUR_GCP_PROJECT_ID"
  region           = "asia-southeast1"
  authorized_cidrs = ["YOUR.PUBLIC.IP/32"]
  ```
- Replace `REPLACE_ME_TFSTATE_BUCKET` in each env's `backend.tf` with your bucket name
  (or let the GitHub Actions workflow patch it via `sed`).

## Usage (Local)
```bash
cd envs/dev   # or envs/prod
terraform init
terraform plan -out tfplan
terraform apply tfplan

# get kubeconfig
../../scripts/print-creds.sh envs/dev
kubectl get nodes
```

## GitHub Actions (CI/CD)
- Create repo secrets:
  - `GCP_PROJECT_ID` = your project ID
  - `GCP_SA_KEY` = JSON key for a **least-privileged** service account (e.g., roles/container.admin, compute.networkAdmin, iam.serviceAccountAdmin as needed)
  - `TF_STATE_BUCKET` = your remote state bucket
- Workflows:
  - `.github/workflows/terraform-dev.yml`
  - `.github/workflows/terraform-prod.yml`
- Behavior:
  - On PR: `plan` only
  - On push to `main` or manual dispatch: `apply`

## Cost Tips
- Autopilot charges per Pod usage. Start small (e.g., requests: 0.25 vCPU / 256Mi) and use HPA.
- Delete unused Services of type LoadBalancer to avoid Egress/LB costs.
- Use Spot Pods for tolerant workloads.
