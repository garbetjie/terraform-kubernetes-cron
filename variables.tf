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

variable mount_host_path {
  type = string
  default = null
}

variable volumes_from_secrets {
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

locals {
  labels = merge(var.labels, { cron-job = var.name })
}
