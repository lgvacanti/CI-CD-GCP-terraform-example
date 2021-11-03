terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials)

  project = var.project
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_sourcerepo_repository" "repo" {
  name = "repo"
}

resource "google_cloudbuild_trigger" "trigger" {
  trigger_template {
    branch_name = "main"
    repo_name   = google_sourcerepo_repository.repo.name
  }

  filename = "buildtemplate.yaml"
}

output "repo-url" {
  value = google_sourcerepo_repository.repo.url
}
