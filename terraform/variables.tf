# Variable definitions

variable "project" {
  description = "GCP project id"
  type        = string
}

variable "credentials" {
  description = "Location of your GCP credentials file, e.g. /home/user/<projectid>.json"
  type        = string
}
