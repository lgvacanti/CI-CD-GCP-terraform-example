# CI-CD-GCP-terraform-example
An example/practice repository for setting up a CI/CD pipeline. Set up on GCP with Terraform.

Based on chapter 7 of 'Terraform in Action', but with some changes of my own.

The pipeline:
- Code is pushed to Cloud Source Repositories
- This triggers a Cloud Build build, with the template based on the `buildtemplate.yaml` file
- The Cloud Build:
  - Builds the Docker app in the `app` folder
  - Pushes the image to the Container Registry
  - Deploys the image to Cloud Run


## Terraform steps
1. Create a GCP project
2. Create a service account with the Project/Editor, Project IAM Admin, Security Admin, and Source Repository Administrator roles.
3. Create and download a key for the service account
4. Create a `terraform.tfvars` file in the `terraform` folder that contains the `project` variable with your project ID and the `credentials` variable with the location of your credentials file.
5. Enable the following APIs for your project:
   - https://console.cloud.google.com/apis/library/sourcerepo.googleapis.com
   - https://console.cloud.google.com/apis/library/cloudbuild.googleapis.com
   - https://console.cloud.google.com/apis/library/run.googleapis.com
   - https://console.cloud.google.com/apis/library/iam.googleapis.com
   - https://console.cloud.google.com/apis/library/cloudresourcemanager.googleapis.com
6. Run `terraform init`
7. Run `terraform apply`
8. Type `yes` and hit enter.
9.  You can run `terraform destroy` to destroy the provisioned resources.


Terraform will output 2 urls. One is the url of your app, the other is the url of the Cloud Source Repository. You can set this as a remote for the git repository you have with `git remote add google <url>` and then push to that remote with `git push --all google`

## Run build from GitHub repository
You can set a Cloud Source Repository to mirror a GitHub repository, but you can't (yet) do this with Terraform, so if you want to do this you will have to do it manually.