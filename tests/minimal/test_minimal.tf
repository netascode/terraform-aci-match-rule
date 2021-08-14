terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "netascode/aci"
      version = ">=0.2.0"
    }
  }
}

resource "aci_rest" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
}

module "main" {
  source = "../.."

  tenant = aci_rest.fvTenant.content.name
  name   = "MR1"
}

data "aci_rest" "rtctrlSubjP" {
  dn = "${aci_rest.fvTenant.id}/subj-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlSubjP" {
  component = "rtctrlSubjP"

  equal "name" {
    description = "name"
    got         = data.aci_rest.rtctrlSubjP.content.name
    want        = module.main.name
  }
}
