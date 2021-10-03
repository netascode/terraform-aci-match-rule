module "aci_match_rule" {
  source  = "netascode/match-rule/aci"
  version = ">= 0.0.1"

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
