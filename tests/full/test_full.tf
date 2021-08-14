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

  tenant      = aci_rest.fvTenant.content.name
  name        = "MR1"
  description = "My Description"
  prefixes = [{
    ip          = "10.1.1.0/24"
    description = "Prefix Description"
    aggregate   = true
    from_length = 25
    to_length   = 32
  }]
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

  equal "descr" {
    description = "descr"
    got         = data.aci_rest.rtctrlSubjP.content.descr
    want        = "My Description"
  }
}

data "aci_rest" "rtctrlMatchRtDest" {
  dn = "${data.aci_rest.rtctrlSubjP.id}/dest-[10.1.1.0/24]"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlMatchRtDest" {
  component = "rtctrlMatchRtDest"

  equal "ip" {
    description = "ip"
    got         = data.aci_rest.rtctrlMatchRtDest.content.ip
    want        = "10.1.1.0/24"
  }

  equal "aggregate" {
    description = "aggregate"
    got         = data.aci_rest.rtctrlMatchRtDest.content.aggregate
    want        = "yes"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest.rtctrlMatchRtDest.content.descr
    want        = "Prefix Description"
  }

  equal "fromPfxLen" {
    description = "fromPfxLen"
    got         = data.aci_rest.rtctrlMatchRtDest.content.fromPfxLen
    want        = "25"
  }

  equal "toPfxLen" {
    description = "toPfxLen"
    got         = data.aci_rest.rtctrlMatchRtDest.content.toPfxLen
    want        = "32"
  }
}
