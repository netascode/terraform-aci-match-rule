resource "aci_rest_managed" "rtctrlSubjP" {
  dn         = "uni/tn-${var.tenant}/subj-${var.name}"
  class_name = "rtctrlSubjP"
  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest_managed" "rtctrlMatchRtDest" {
  for_each   = { for prefix in var.prefixes : prefix.ip => prefix }
  dn         = "${aci_rest_managed.rtctrlSubjP.dn}/dest-[${each.value.ip}]"
  class_name = "rtctrlMatchRtDest"
  content = {
    ip         = each.value.ip
    aggregate  = each.value.aggregate == true ? "yes" : "no"
    descr      = each.value.description
    fromPfxLen = each.value.from_length
    toPfxLen   = each.value.to_length
  }
}
