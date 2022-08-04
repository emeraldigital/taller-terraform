resource "random_integer" "int" {
  max = 100
  min = 0
}

output "conditional" {
  value = random_integer.int.result % 2 == 0 ? "even" : "odd"
}
