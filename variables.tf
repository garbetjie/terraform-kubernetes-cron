variable name {
  type = string
}

variable namespace {
  type = string
}

variable schedule {
  type = string
}

variable args {
  type = list(string)
  default = []
}

variable labels {
  type = map(string)
  default = {}
}

variable image_pull_policy {
  type = string
  default = "Always"
}

variable env {
  type = map(string)
  default = {}
}

variable env_from_secrets {
  type = set(string)
  default = []
}

variable mount_host_paths {
  type = map(string)
  default = null
}

variable mount_secrets {
  type = list(object({ secret = string, path = string, items = set(string) }))
  default = []
}

variable image {
  type = string
}

variable concurrency_policy {
  type = string
  default = "Forbid"
}

variable wait_for_rollout {
  type = bool
  default = true
}

variable tolerations {
  type = list(object({ key = string, value = string }))
  default = []
}

variable node_selector {
  type = map(string)
  default = {}
}

locals {
  labels = merge(var.labels, { cron-job = var.name })

  mount_host_paths = {
    for key, value in var.mount_host_paths:
      "hosts-${sha256(key, 0, 4)}" => { host_path = key, mount_path = value }
  }

  mount_secrets = {
    for key, value in var.mount_secrets:
      "secret-${value.secret}" => value
  }
}
