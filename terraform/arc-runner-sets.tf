## to add new change configurl value to new repo and make helm_release name unique

#resource "helm_release" "arc_runner_set" {
#  name             = "arc-runner-set"
#  namespace        = "arc-runners"
#  create_namespace = true
#  repository       = "oci://ghcr.io/actions/actions-runner-controller-charts"
#  chart            = "gha-runner-scale-set"
#  wait             = true
#  
#  set = [ {
#    name = "githubConfigUrl"
#    value = "https://github.com/maxkoskinen/dabs-project-2"
#  } ]
#  set_sensitive = [ {
#    name = "githubConfigSecret.github_token"
#    value = var.github_pat
#  } ]
#}
