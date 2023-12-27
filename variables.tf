/*
Contains variable uses for installing Qualys Cloud Agent

Author: qoolbreeze
*/

variable "project" { 
  type= string
  description = "GCP project"
}

variable "activation_id" {
  type = string
  description = "Qualys Activation ID (unique per BU)"
  validation {
    condition = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.activation_id))
    error_message = "The activation_id is not in uuidv4 form."
  } 
}

variable "customer_id" {
  type = string
  description = "Qualys Customer ID (unique for all organization)"
  validation {
    condition = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.customer_id))
    error_message = "The customer_id is not in uuidv4 form."
  }
}

variable "cidrs-destination" { 
    type = list
    description = "List of CIDR ranges of Qualys"
    default = ["154.59.121.0/24"] 
}

variable "fw-priority" {
    type = number
    default = 1
    description = "Firewall rule priority"
}

variable "bucket-name" {
  type = string
  description = "Name of the bucket"
}

variable "debian-package-name" {
  type = string
  description = "Name of the debian package"
  default = "qualys/cloudagent/linux/x64/latest/qualys-cloud-agent.x86_64.deb"
}

variable "rhel-package-name" {
  type = string
  description = "Name of the RPM package"
  default = "qualys/cloudagent/linux/x64/latest/qualys-cloud-agent.x86_64.rpm"
}

variable "win-package-name" {
  type = string
  description = "Name of the Windows binary"
  default = "qualys/cloudagent/linux/x64/latest/QualysCloudAgent.exe"
}

variable "debian-package-generation-number" {
  type = number
  description = "Generation number of the debian package"
}

variable "rhel-package-generation-number" {
  type = number
  description = "Generation number of the RPM package"
}

variable "win-package-generation-number" {
  type = number
  description = "Generation number of the Windows binary"
}


variable "cs-retention-period" {
  type = number
  default = 0
  description = "Retention Period for the bucket in second"
} 

variable "qualys-guest-policies" {
  default = {
    debian = {
      name = "qualys-cloud-agent-debian-deploiement"
      guest_policy_id = "guest-policy-qualys-cloud-agent-deb"
      local_path = "/usr/local/qualys/cloud-agent/bin/qualys-cloud-agent.sh"
    }

    windows = {
      name = "qualys-cloud-agent-win-deploiement"
      guest_policy_id = "guest-policy-qualys-cloud-agent-win"
    }

    redhat = {
      name = "qualys-cloud-agent-rhel-deploiement"
      guest_policy_id = "guest-policy-qualys-cloud-agent-rhel"
      local_path = "/usr/local/qualys/cloud-agent/bin/qualys-cloud-agent.sh"
      }
    }
}

variable "qualys_server_url" {
  type = string
  description = "qualys server url. Must end by '/CloudAgent'"
}

locals {
  debian_args = [
          "ActivationId=${var.activation_id}",
          "CustomerId=${var.customer_id}",
          "ServerUri=${var.qualys_server_url}"
        ]

  rhel_args = [
          "ActivationId=${var.activation_id}",
          "CustomerId=${var.customer_id}",
          "ServerUri=${var.qualys-server-url}"
        ]
  windows_args = [
        "ActivationId=${var.activation_id}",
        "CustomerId=${var.customer_id}",
        "ServerUri=${var.qualys-server-url}",
        "WebServiceUri=${var.qualys-server-url}",
        "WebServicePort=443",
        "WebServiceSecure=1",
        "ProviderName=GCP",
        ]
}

