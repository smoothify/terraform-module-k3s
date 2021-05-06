output "kubernetes" {
  description = "Authentication credentials of Kubernetes (full administrator)."
  value = {
    cluster_ca_certificate = local.cluster_ca_certificate
    client_certificate     = local.client_certificate
    client_key             = local.client_key
    api_endpoint           = "https://${local.root_server_connection.host}:6443"
    password               = null
    username               = null
  }
  sensitive = true
}

output "kube_config" {
  description = "Generated kubeconfig."
  value = var.generate_ca_certificates == false ? null : yamlencode({
    apiVersion = "v1"
    clusters = [{
      cluster = {
        certificate-authority-data = base64encode(local.cluster_ca_certificate)
        server                     = "https://${local.root_server_connection.host}:6443"
      }
      name = var.name
    }]
    contexts = [{
      context = {
        cluster = var.name
        user : local.cluster_username
      }
      name = var.name
    }]
    current-context = var.name
    kind            = "Config"
    preferences     = {}
    users = [{
      user = {
        client-certificate-data : base64encode(local.client_certificate)
        client-key-data : base64encode(local.client_key)
      }
      name : local.cluster_username
    }]
  })
  sensitive = true
}

output "kube_config_internal" {
  description = "Generated kubeconfig."
  value = var.generate_ca_certificates == false ? null : yamlencode({
    apiVersion = "v1"
    clusters = [{
      cluster = {
        certificate-authority-data = base64encode(local.cluster_ca_certificate)
        server                     = "https://${local.root_server_connection.ip_internal}:6443"
      }
      name = var.name
    }]
    contexts = [{
      context = {
        cluster = var.name
        user : local.cluster_username
      }
      name = var.name
    }]
    current-context = var.name
    kind            = "Config"
    preferences     = {}
    users = [{
      user = {
        client-certificate-data : base64encode(local.client_certificate)
        client-key-data : base64encode(local.client_key)
      }
      name : local.cluster_username
    }]
  })
  sensitive = true
}


output "summary" {
  description = "Current state of k3s (version & nodes)."
  value = {
    version : local.k3s_version
    servers : [
      for key, server in var.servers :
      {
        name        = local.servers_metadata[key].name
        annotations = try(server.annotations, [])
        labels      = try(server.labels, [])
        taints      = try(server.taints, [])
      }
    ]
    agents : [
      for key, agent in var.agents :
      {
        name        = local.agents_metadata[key].name
        annotations = try(agent.annotations, [])
        labels      = try(agent.labels, [])
        taints      = try(agent.taints, [])
      }
    ]
  }
}

output "kubernetes_ready" {
  description = "Dependency endpoint to synchronize k3s installation and provisioning."
  value       = null_resource.kubernetes_ready
}
