output "get_credentials_cmd" {
  value = "gcloud container clusters get-credentials ${module.gke.cluster_name} --region ${module.gke.cluster_location} --project ${var.project_id}"
}
output "cluster_name"     { value = module.gke.cluster_name }
output "cluster_location" { value = module.gke.cluster_location }
output "gsa_email"        { value = module.iam_app.gsa_email }
