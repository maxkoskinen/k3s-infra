locals {
  kube-prometheus-operator_version = "v0.83.0" # NOTE: This is used only for Prometheus-operator CRD update purposes. This is the APP version not the chart version.
}

resource "helm_release" "kube-prometheus-stack" {
  name              = "kube-prometheus-stack"
  chart             = "${path.module}/charts/kube-prometheus-stack"
  namespace         = "monitoring"
  create_namespace  = true
  dependency_update = true
  wait              = false
  values            = [file("${path.module}/charts/kube-prometheus-stack/values.yaml")]
}

resource "null_resource" "kubectl_kube-prometheus-stack_crds" {
  triggers = {
    version_change = local.kube-prometheus-operator_version
  }

  provisioner "local-exec" {
    command = <<-EOT
      kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/'${local.kube-prometheus-operator_version}'/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagerconfigs.yaml --force-conflicts
      kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/'${local.kube-prometheus-operator_version}'/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagers.yaml --force-conflicts
      kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/'${local.kube-prometheus-operator_version}'/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml --force-conflicts
      kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/'${local.kube-prometheus-operator_version}'/example/prometheus-operator-crd/monitoring.coreos.com_probes.yaml --force-conflicts
      kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/'${local.kube-prometheus-operator_version}'/example/prometheus-operator-crd/monitoring.coreos.com_prometheusagents.yaml --force-conflicts
      kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/'${local.kube-prometheus-operator_version}'/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml --force-conflicts
      kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/'${local.kube-prometheus-operator_version}'/example/prometheus-operator-crd/monitoring.coreos.com_prometheusrules.yaml --force-conflicts
      kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/'${local.kube-prometheus-operator_version}'/example/prometheus-operator-crd/monitoring.coreos.com_scrapeconfigs.yaml --force-conflicts
      kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/'${local.kube-prometheus-operator_version}'/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml --force-conflicts
      kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/'${local.kube-prometheus-operator_version}'/example/prometheus-operator-crd/monitoring.coreos.com_thanosrulers.yaml --force-conflicts
    EOT
  }
}