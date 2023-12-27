provider "google" {
  project = var.project
}

terraform {
  required_providers {
    google = {
      version = "~> 5.10.0"
    }
    google-beta = {
      version = "~> 5.10.0" 
    }
  }
}

