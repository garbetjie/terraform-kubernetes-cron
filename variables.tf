variable name {
  type = string
}

variable namespace {
  type = string
}

variable command {
  type = list(string)
}

variable labels {
  type = map(string)
  default = {}
}

variable image_pull_policy {
  type = string
  default = "Always"
}

variable schedule {
  type = string
}

variable env {
  type = map(string)
  default = {}
}

variable env_from_secrets {
  type = set(string)
  default = []
}

variable mount_host_path {
  type = string
  default = null
}

variable secret_volumes {
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
  default = false
}

locals {
  labels = merge(var.labels, { cron-job = var.name })
}
