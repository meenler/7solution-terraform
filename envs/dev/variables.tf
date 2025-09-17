variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "asia-southeast1" # Singapore
}

variable "authorized_cidrs" {
  type        = list(string)
  description = "List of IP/CIDR allowed to access GKE control plane"
}
