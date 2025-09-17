resource "google_service_account" "gsa" {
  account_id   = var.gsa_name
  display_name = var.gsa_name
}

resource "google_project_iam_member" "bindings" {
  for_each = toset(var.roles)
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.gsa.email}"
}

output "gsa_email" { value = google_service_account.gsa.email }
