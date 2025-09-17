terraform {
  backend "gcs" {
    bucket = "gcp-7solution-bucket"   # TODO: replace with your bucket name
    prefix = "terraform/dev"
  }
}
