output "example" {
  value = local.example_var
}

output "project" {
  value = local.welcome
}

output "variable_sensible" {
  value = uuid()
  sensitive = true
}
