<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-match-rule/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-match-rule/actions/workflows/test.yml)

# Terraform ACI Match Rule Module

Manages ACI Match Rule

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `Match Rules`

## Examples

```hcl
module "aci_match_rule" {
  source = "netascode/match-rule/aci"

  tenant      = "ABC"
  name        = "MR1"
  description = "My Description"
  prefixes = [{
    ip          = "10.1.1.0"
    description = "Prefix Description"
    aggregate   = true
    from_length = 25
    to_length   = 32
  }]
}

```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 0.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 0.2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Match rule tenant. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Match rule name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_prefixes"></a> [prefixes](#input\_prefixes) | List of prefixes. Default value `aggregate`: false. Allowed values `from_length`: 0-128. Allowed values `to_length`: 0-128. | <pre>list(object({<br>    ip          = string<br>    description = optional(string)<br>    aggregate   = optional(bool)<br>    from_length = optional(number)<br>    to_length   = optional(number)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `rtctrlSubjP` object. |
| <a name="output_name"></a> [name](#output\_name) | Match rule name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest.rtctrlMatchRtDest](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.rtctrlSubjP](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
<!-- END_TF_DOCS -->