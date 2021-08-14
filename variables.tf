variable "tenant" {
  description = "Match rule tenant."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "Match rule name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "Description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "prefixes" {
  description = "List of prefixes. Default value `aggregate`: false. Allowed values `from_length`: 0-128. Allowed values `to_length`: 0-128."
  type = list(object({
    ip          = string
    description = optional(string)
    aggregate   = optional(bool)
    from_length = optional(number)
    to_length   = optional(number)
  }))
  default = []

  validation {
    condition = alltrue([
      for p in var.prefixes : p.description == null || can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", p.description))
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue([
      for p in var.prefixes : p.from_length == null || try(p.from_length >= 0 && p.from_length <= 128, false)
    ])
    error_message = "`from_length`: Minimum value: 0. Maximum value: 128."
  }

  validation {
    condition = alltrue([
      for p in var.prefixes : p.to_length == null || try(p.to_length >= 0 && p.to_length <= 128, false)
    ])
    error_message = "`to_length`: Minimum value: 0. Maximum value: 128."
  }
}
