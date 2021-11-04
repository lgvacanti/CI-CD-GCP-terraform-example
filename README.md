# CI-CD-GCP-terraform-example
An example/practice repository for setting up a CI/CD pipeline. Set up on GCP with Terraform.


The pipeline:
- Code is pushed to Cloud Source Repositories
- This triggers a Cloud Build build, with the template based on the `buildtemplate.yaml` file
- The Cloud Build:
  - Builds the Docker app in the `app` folder
  - Pushes the image to the Container Registry
  - Deploys the image to Cloud Run