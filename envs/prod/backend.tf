terraform {
  backend "gcs" {
    bucket = "7solution-bucket-472509"   # TODO: replace with your bucket name
    prefix = "terraform/prod"
  }
}
