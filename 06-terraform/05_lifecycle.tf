resource "random_string" "create_before_destroy" {
  length = 5

  lifecycle {
    create_before_destroy = true
  }
}

resource "random_string" "prevent_destroy" {
  length = 5

  lifecycle {
    prevent_destroy = true
  }
}