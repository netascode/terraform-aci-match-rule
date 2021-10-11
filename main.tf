resource "aci_rest" "rtctrlSubjP" {
  dn         = "uni/tn-${var.tenant}/subj-${var.name}"
  class_name = "rtctrlSubjP"
  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest" "rtctrlMatchRtDest" {
  for_each   = { for prefix in var.prefixes : prefix.ip => prefix }
  dn         = "${aci_rest.rtctrlSubjP.dn}/dest-[${each.value.ip}]"
  class_name = "rtctrlMatchRtDest"
  content = {
    ip         = each.value.ip
    aggregate  = each.value.aggregate == true ? "yes" : "no"
    descr      = each.value.description != null ? each.value.description : ""
    fromPfxLen = each.value.from_length != null ? each.value.from_length : 0
    toPfxLen   = each.value.to_length != null ? each.value.to_length : 0
  }
}
