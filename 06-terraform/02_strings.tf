output "simple_string" {
  value = "Hello World"
}

output "template_string" {
  value = "Hello, my uuid is ${uuid()}"
}

output "heredoc" {
  value = <<-EOT
    Hello World
    This is a multi-line string
    and it can use templates too: ${uuid()}
  EOT
}
