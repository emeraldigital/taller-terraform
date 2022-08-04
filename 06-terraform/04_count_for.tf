locals {
  count_example = ["count 1", "count 2", "count 3"]
  for_example   = ["for 1", "for 2", "for 3"]
}

resource "null_resource" "count" {
  count = length(local.count_example)

  triggers = {
    always = uuid()
  }

  provisioner "local-exec" {
    command = "echo ${element(local.count_example, count.index)}"
  }
}

resource "null_resource" "for" {
  for_each = toset(local.for_example)

  triggers = {
    always = uuid()
  }

  provisioner "local-exec" {
    command = "echo ${each.key}"
  }

  depends_on = [null_resource.count]
}
