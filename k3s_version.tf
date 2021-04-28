// Fetch the last version of k3s
data "http" "k3s_version" {
  url = "https://update.k3s.io/v1-release/channels"
}

locals {
  // Use the fetched version if 'latest' is specified
  
  k3s_version_data = jsondecode(data.http.k3s_version.body).data 
  
  k3s_version_map = {
    stable = local.k3s_version_data[0].latest
    latest = local.k3s_version_data[1].latest
  }
  
  k3s_version = lookup(local.k3s_version_map, var.k3s_version, var.k3s_version)
}

// Fetch the k3s installation script
data "http" "k3s_installer" {
  url = "https://raw.githubusercontent.com/rancher/k3s/${local.k3s_version}/install.sh"
}
