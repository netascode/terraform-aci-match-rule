output "dn" {
  value       = aci_rest.rtctrlSubjP.id
  description = "Distinguished name of `rtctrlSubjP` object."
}

output "name" {
  value       = aci_rest.rtctrlSubjP.content.name
  description = "Match rule name."
}
