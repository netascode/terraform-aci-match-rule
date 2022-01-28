terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "CiscoDevNet/aci"
      version = ">=2.0.0"
    }
  }
}

resource "aci_rest_managed" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
}

module "main" {
  source = "../.."

  tenant      = aci_rest_managed.fvTenant.content.name
  name        = "MR1"
  description = "My Description"
  # prefixes = [{
  #   ip          = "10.1.1.0/24"
  #   description = "Prefix Description"
  #   aggregate   = true
  #   from_length = 25
  #   to_length   = 32
  # }]
}

data "aci_rest_managed" "rtctrlSubjP" {
  dn = "${aci_rest_managed.fvTenant.id}/subj-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlSubjP" {
  component = "rtctrlSubjP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.rtctrlSubjP.content.name
    want        = module.main.name
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.rtctrlSubjP.content.descr
    want        = "My Description"
  }
}

# data "aci_rest_managed" "rtctrlMatchRtDest" {
#   dn = "${data.aci_rest_managed.rtctrlSubjP.id}/dest-[10.1.1.0/24]"

#   depends_on = [module.main]
# }

# resource "test_assertions" "rtctrlMatchRtDest" {
#   component = "rtctrlMatchRtDest"

#   equal "ip" {
#     description = "ip"
#     got         = data.aci_rest_managed.rtctrlMatchRtDest.content.ip
#     want        = "10.1.1.0/24"
#   }

#   equal "aggregate" {
#     description = "aggregate"
#     got         = data.aci_rest_managed.rtctrlMatchRtDest.content.aggregate
#     want        = "yes"
#   }

#   equal "descr" {
#     description = "descr"
#     got         = data.aci_rest_managed.rtctrlMatchRtDest.content.descr
#     want        = "Prefix Description"
#   }

#   equal "fromPfxLen" {
#     description = "fromPfxLen"
#     got         = data.aci_rest_managed.rtctrlMatchRtDest.content.fromPfxLen
#     want        = "25"
#   }

#   equal "toPfxLen" {
#     description = "toPfxLen"
#     got         = data.aci_rest_managed.rtctrlMatchRtDest.content.toPfxLen
#     want        = "32"
#   }
# }
