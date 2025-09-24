resource "helm_release" "csi-driver-nfs" {
  name             = "csi-driver-nfs"
  repository       = "https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts"
  chart            = "csi-driver-nfs"
  namespace        = "kube-system"
  create_namespace = false
  wait             = false
  values           = [file("${path.module}/charts/csi-driver-nfs/values.yaml")]
  version          = "v4.5.0"
}

data "archive_file" "nfs-storageclasses" {
  type        = "zip"
  source_dir  = "${path.module}/charts/csi-driver-nfs/storageclasses/"
  output_path = "${path.module}/archive/nfs-storageclasses.zip"
}

resource "null_resource" "csi-nfs-storageclasses-configs" {
  depends_on = [
    helm_release.csi-driver-nfs
  ]
  triggers = {
    src_hash = "${data.archive_file.nfs-storageclasses.output_sha}"
    # always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
      kubectl apply -f ${path.module}/charts/csi-driver-nfs/storageclasses/
   EOT
  }
}

#data "archive_file" "nfs-snapshotclasses" {
#  type        = "zip"
#  source_dir = "${path.module}/charts/csi-driver-nfs/snapshotclasses/"
#  output_path = "nfs-snapshotclasses.zip"
#}

#resource "null_resource" "csi-nfs-snapshotclasses-configs" {
#  depends_on = [
#     helm_release.csi-driver-nfs
#   ]
#  triggers = {
#    src_hash = "${data.archive_file.nfs-snapshotclasses.output_sha}"
#    # always_run = "${timestamp()}"
#  }
#
#  provisioner "local-exec" {
#    command = <<EOT
#      kubectl apply -f ${path.module}/charts/csi-driver-nfs/snapshotclasses/
#   EOT
#  }
#}