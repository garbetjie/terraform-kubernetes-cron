output name {
  value = kubernetes_cron_job.cron.metadata[0].name
}

output labels {
  value = kubernetes_cron_job.cron.metadata[0].labels
}
