# Sin valor por defecto
variable "PROJECT_ID" {
  type = string
}

# Con valor por defecto
variable "REGION" {
  type = string
  description = "Default region"
  default = "us-central1"
}

# Variable sin valor por defecto, pero con referencia en el archivo de variables
variable "EXAMPLE" {
  type = string
}