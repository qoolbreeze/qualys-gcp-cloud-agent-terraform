# terraform-qualys-ca-gcp

Deploy Qualys Cloud Agent on a single GCP using Terraform
Cloud agents will be automaticaly provisionned thanks to guest policies.

Deployment will be effective for RedHat, Windows, Debian and Ubuntu Operating system.

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_google"></a> [google](#requirement\_google) (~> 5.10.0)

- <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) (~> 5.10.0)

## Providers

The following providers are used by this module:

- <a name="provider_google"></a> [google](#provider\_google) (~> 5.10.0)

- <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) (~> 5.10.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [google-beta_google_os_config_guest_policies.guest-policies-debian](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_os_config_guest_policies) (resource)
- [google-beta_google_os_config_guest_policies.guest-policies-rhel](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_os_config_guest_policies) (resource)
- [google-beta_google_os_config_guest_policies.guest-policies-windows](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_os_config_guest_policies) (resource)
- [google_compute_firewall.qualys-egress-fw](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) (resource)
- [google_compute_project_metadata_item.qualys-os-config-metadata](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_project_metadata_item) (resource)
- [google_project_service.qualys-os-config-service](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) (resource)
- [google_storage_bucket.qualys-ca-bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) (resource)
- [google_storage_bucket_object.deb-package](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object) (resource)
- [google_storage_bucket_object.rhel-package](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object) (resource)
- [google_storage_bucket_object.win-package](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_activation_id"></a> [activation\_id](#input\_activation\_id)

Description: Qualys Activation ID (unique per BU)

Type: `string`

### <a name="input_bucket-name"></a> [bucket-name](#input\_bucket-name)

Description: Name of the bucket

Type: `string`

### <a name="input_customer_id"></a> [customer\_id](#input\_customer\_id)

Description: Qualys Customer ID (unique for all organization)

Type: `string`

### <a name="input_debian-package-generation-number"></a> [debian-package-generation-number](#input\_debian-package-generation-number)

Description: Generation number of the debian package

Type: `number`

### <a name="input_project"></a> [project](#input\_project)

Description: GCP project

Type: `string`

### <a name="input_qualys_server_url"></a> [qualys\_server\_url](#input\_qualys\_server\_url)

Description: qualys server url. Must end by '/CloudAgent'

Type: `string`

### <a name="input_rhel-package-generation-number"></a> [rhel-package-generation-number](#input\_rhel-package-generation-number)

Description: Generation number of the RPM package

Type: `number`

### <a name="input_win-package-generation-number"></a> [win-package-generation-number](#input\_win-package-generation-number)

Description: Generation number of the Windows binary

Type: `number`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_cidrs-destination"></a> [cidrs-destination](#input\_cidrs-destination)

Description: List of CIDR ranges of Qualys

Type: `list`

Default:

```json
[
  "154.59.121.0/24"
]
```

### <a name="input_cs-retention-period"></a> [cs-retention-period](#input\_cs-retention-period)

Description: Retention Period for the bucket in second

Type: `number`

Default: `0`

### <a name="input_debian-package-name"></a> [debian-package-name](#input\_debian-package-name)

Description: Name of the debian package

Type: `string`

Default: `"qualys/cloudagent/linux/x64/latest/qualys-cloud-agent.x86_64.deb"`

### <a name="input_fw-priority"></a> [fw-priority](#input\_fw-priority)

Description: Firewall rule priority

Type: `number`

Default: `1`

### <a name="input_qualys-guest-policies"></a> [qualys-guest-policies](#input\_qualys-guest-policies)

Description: n/a

Type: `map`

Default:

```json
{
  "debian": {
    "guest_policy_id": "guest-policy-qualys-cloud-agent-deb",
    "local_path": "/usr/local/qualys/cloud-agent/bin/qualys-cloud-agent.sh",
    "name": "qualys-cloud-agent-debian-deploiement"
  },
  "redhat": {
    "guest_policy_id": "guest-policy-qualys-cloud-agent-rhel",
    "local_path": "/usr/local/qualys/cloud-agent/bin/qualys-cloud-agent.sh",
    "name": "qualys-cloud-agent-rhel-deploiement"
  },
  "windows": {
    "guest_policy_id": "guest-policy-qualys-cloud-agent-win",
    "name": "qualys-cloud-agent-win-deploiement"
  }
}
```

### <a name="input_rhel-package-name"></a> [rhel-package-name](#input\_rhel-package-name)

Description: Name of the RPM package

Type: `string`

Default: `"qualys/cloudagent/linux/x64/latest/qualys-cloud-agent.x86_64.rpm"`

### <a name="input_win-package-name"></a> [win-package-name](#input\_win-package-name)

Description: Name of the Windows binary

Type: `string`

Default: `"qualys/cloudagent/linux/x64/latest/QualysCloudAgent.exe"`

## Outputs

No outputs.
<!-- END_TF_DOCS -->
