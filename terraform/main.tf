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

  substitutions = {
    _CLOUD_RUN_NAME = google_cloud_run_service.cloud_run.name
    _REGION         = "us-central1"
  }


  filename = "buildtemplate.yaml"
}

data "google_project" "project" {

}

resource "google_project_iam_member" "cloudbuild_roles" {
  for_each = toset(["roles/run.admin", "roles/iam.serviceAccountUser"])
  project  = var.project
  role     = each.key
  member   = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_cloud_run_service" "cloud_run" {
  name     = "container"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }
}

data "google_iam_policy" "admin" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}
resource "google_cloud_run_service_iam_policy" "policy" {
  location    = "us-central1"
  project     = var.project
  service     = google_cloud_run_service.cloud_run.name
  policy_data = data.google_iam_policy.admin.policy_data
}

output "repo-url" {
  value = google_sourcerepo_repository.repo.url
}

output "app-url" {
  value = google_cloud_run_service.cloud_run.status[0].url
}
