variable "PROJECT_ID" {
  type = string
}

variable "NETWORK" {
  type = string
}

variable "REGION" {
  type    = string
  default = "us-east1"
}

variable "MACHINE_TYPE" {
  type    = string
  default = "e2-micro"
}

variable "N_INSTANCES" {
  type    = number
  default = 3
}

variable "ALLOW_SSH" {
  type = bool
  default = false
}
