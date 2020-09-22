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
            node_selector = var.node_selector

            container {
              name = "cron"
              image = var.image
              image_pull_policy = var.image_pull_policy
              args = var.args

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
                for_each = local.mount_host_paths

                content {
                  mount_path = volume_mount.value.mount_path
                  name = volume_mount.key
                }
              }

              dynamic "volume_mount" {
                for_each = local.mount_secrets
                content {
                  mount_path = volume_mount.value.path
                  name = volume_mount.key
                }
              }
            }

            dynamic "toleration" {
              for_each = var.tolerations
              content {
                key = toleration.value.key
                value = toleration.value.value
              }
            }

            dynamic "volume" {
              for_each = local.mount_host_paths
              content {
                name = volume.key
                host_path {
                  path = volume.value.host_path
                  type = "Directory"
                }
              }
            }

            dynamic "volume" {
              for_each = local.mount_secrets
              content {
                name = volume.key
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
