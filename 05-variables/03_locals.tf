data "google_project" "example" {
}

locals {
  example_var = "HelloWorld"
  welcome = "Welcome to project ${data.google_project.example.name}"
}
