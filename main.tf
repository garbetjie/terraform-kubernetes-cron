resource kubernetes_cron_job cron {
  metadata {
    namespace = var.namespace
    name = var.name
    labels = local.labels
  }

  spec {
    schedule = var.schedule
    concurrency_policy = var.concurrency_policy
    failed_jobs_history_limit = 3

    job_template {
      metadata {
        labels = local.labels
      }

      spec {
        template {
          metadata {
            labels = local.labels
          }

          spec {
            container {
              name = "cron-job"
              image = var.image
              image_pull_policy = var.image_pull_policy

              dynamic "env" {
                for_each = var.env
                content {
                  name = env.key
                  value = env.value
                }
              }

              dynamic "env_from" {
                for_each = var.env_from_secrets
                content {
                  secret_ref {
                    name = env_from.value
                  }
                }
              }

              dynamic "volume_mount" {
                for_each = var.mount_host_path == null ? [] : [var.mount_host_path]

                content {
                  mount_path = split(":", volume_mount.value)[1]
                  name = "src"
                }
              }

              dynamic "volume_mount" {
                for_each = var.secret_volumes
                content {
                  mount_path = volume_mount.value.path
                  name = "secret-${volume_mount.value.secret}"
                }
              }
            }

            dynamic "volume" {
              for_each = var.mount_host_path == null ? [] : [var.mount_host_path]
              content {
                name = "src"
                host_path {
                  path = split(":", volume.value)[0]
                  type = "Directory"
                }
              }
            }

            dynamic "volume" {
              for_each = var.secret_volumes
              content {
                name = "secret-${volume.value.secret}"
                secret {
                  secret_name = volume.value.secret
                  optional = false
                  dynamic "items" {
                    for_each = volume.value.items
                    content {
                      key = items.value
                      path = items.value
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}