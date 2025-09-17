variable "project_id" { type = string }
variable "gsa_name"   { type = string }
variable "roles" {
  type    = list(string)
  default = ["roles/storage.objectViewer"]
}
