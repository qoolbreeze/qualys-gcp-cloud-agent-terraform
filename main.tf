/*
This terraform script install Qualys Cloud Agent in GCP projects

Details:
  - Enable os-config
  - Set metadata os-config to True
  - create cloud storage bucket with retention policy
  - Create a firewall Egress rule to join Qualys SaaS platform
  - Create guest policies

Author: qoolbreeze
Version: 0.4.0

Changelog:
[0.1.0] - 2020-11-24 <qoolbreeze>
- init file 
- add os config metadata 

[0.1.1] - 2020-11-27 <qoolbreeze>
- add cloud storage bucket
- add variable system

[0.1.2] - 2020-12-23 <qoolbreeze>
- add local variables
- add guest policies for linux and windows

[0.2.0] - 2020-12-28 <qoolbreeze>
- first test OK

[0.2.1] - 2021-01-06 <qoolbreeze>
- Add Cloud Storage Bucket
- Add binaries in cloud storage

[0.3.0] - 2021-01-07 <qoolbreeze>
- Test with bucket inside project specify OK

[0.4.0] - 2021-02-03 <qoolbreeze>
- After Qualys answer, come back to public cloud storage bucket
- Test on LZ core and LZ V2
*/

//activate api for osconfig
resource "google_project_service" "qualys-os-config-service" {
  project = var.project
  service = "osconfig.googleapis.com"

  disable_dependent_services = true
  disable_on_destroy = true
}

// create osconfig metadata and set it to true
resource "google_compute_project_metadata_item" "qualys-os-config-metadata" {
  project = var.project
  key   = "enable-osconfig"
  value = "true"
}

// create firewall rule
resource "google_compute_firewall" "qualys-egress-fw" {
  name    = "allow-egress-qualys-https"
  description = "Allow Qualys Cloud Agent to join SaaS platform"
  direction = "EGRESS"

  network = google_compute_network.default.name
  priority = var.fw-priority
  destination_ranges = var.cidrs-destination

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

} 

// create cloud storage bucket
resource "google_storage_bucket" "qualys-ca-bucket" {
  project = var.project
  name          = var.bucket-name
  location      = "EU"
  force_destroy = true
  storage_class = "STANDARD"
  uniform_bucket_level_access = true

  labels = { 
    "creator": "operational-security-team",
    "product": "qualys"
  }          
  

  retention_policy {
    is_locked = true
    retention_period = var.cs-retention-period
  }

  versioning {
    enabled = false
  }
}

// debian package
resource "google_storage_bucket_object" "deb-package" {
  name   = var.debian-package-name
  source = "./cloudagent/linux/qualys-cloud-agent.x86_64.deb"
  bucket = var.bucket-name
  metadata = {
    "OS": "debian"
  }
}


// redhat package
resource "google_storage_bucket_object" "rhel-package" {
  name   = var.rhel-package-name
  source = "./cloudagent/linux/qualys-cloud-agent.x86_64.rpm"
  bucket = var.bucket-name
  metadata = {
    "OS": "RedHat"
  }
}

// windows package
resource "google_storage_bucket_object" "win-package" {
  name   = var.win-package-name
  source = "./cloudagent/windows/QualysCloudAgent.exe"
  bucket = var.bucket-name
  metadata = {
    "OS": "Windows"
  }
}

//linux guest policy debian
resource "google_os_config_guest_policies" "guest-policies-debian" {
  provider = google-beta
  project = var.project
  guest_policy_id = var.qualys-guest-policies["debian"]["guest_policy_id"]

  //for UBUNTU and DEBIAN
  assignment {
    os_types {
      os_short_name = "DEBIAN"
    }
    os_types {
      os_short_name = "UBUNTU"
    }
  }

  description = "Install Qualys Cloud Agent on Debian Compute Engines"

  recipes {

    name = var.qualys-guest-policies["debian"]["name"]
    version = 0.2
    desired_state = "INSTALLED"
    
    artifacts {
      id = "installer"
      allow_insecure = false
      gcs {
        bucket = var.bucket-name
        object = var.debian-package-name
        generation = var.debian-package-generation-number
      }
    }

    install_steps {
      dpkg_installation {
        artifact_id = "installer"
      }
    }

    install_steps {
      file_exec {
        args = local.debian_args
        local_path = var.qualys-guest-policies["debian"]["local_path"]
      }
    }
  }
}


//windows guest policy
resource "google_os_config_guest_policies" "guest-policies-windows" {

  provider = google-beta
  project = var.project
  guest_policy_id = var.qualys-guest-policies["windows"]["guest_policy_id"]
  
  //for Windows
  assignment {
    os_types {
      os_short_name = "WINDOWS"
    } 
  }
  description = "Install Qualys Cloud Agent on Windows Compute Engines"

  recipes {

    name = var.qualys-guest-policies["windows"]["name"]
    version = 0.2
    desired_state = "INSTALLED"

    artifacts {
      id = "installer"
      allow_insecure = false
      gcs {
        bucket = var.bucket-name
        object = var.win-package-name
        generation = var.win-package-generation-number
      }
    }

    install_steps {
      file_exec {
        args = local.windows_args
        artifact_id = "installer"
      }
    }
  }
}

//linux guest policy redhat
resource "google_os_config_guest_policies" "guest-policies-rhel" {
  provider = google-beta
  project = var.project
  guest_policy_id = var.qualys-guest-policies["redhat"]["guest_policy_id"]

  //for CENTOS and REDHAT
  assignment {
    os_types {
      os_short_name = "RHEL"
    }
    os_types {
      os_short_name = "CENTOS"
    }
  }

  description = "Install Qualys Cloud Agent on RedHat Compute Engines"

  recipes {

    name = var.qualys-guest-policies["redhat"]["name"]
    version = 0.2
    desired_state = "INSTALLED"
    
    artifacts {
      id = "installer"
      allow_insecure = false
      gcs {
        bucket = var.bucket-name
        object = var.rhel-package-name
        generation = var.rhel-package-generation-number
      }
    }

    install_steps {
      rpm_installation {
        artifact_id = "installer"
      }
    }

    install_steps {
      file_exec {
        args = local.rhel_args
        local_path = var.qualys-guest-policies["redhat"]["local_path"]
      }
    }
  }
}

