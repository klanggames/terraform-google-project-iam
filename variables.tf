# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "project" {
  type        = string
  description = "(Required) The project ID."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "role" {
  type        = string
  description = "(Optional) The role that should be applied. Only one google_project_iam_binding can be used per role. Note that custom roles must be of the format organizations/{{org_id}}/roles/{{role_id}}."
  default     = null
}

variable "members" {
  type        = set(string)
  description = "(Optional) Identities that will be granted the privilege in role. Each entry can have one of the following values: 'user:{emailid}', 'serviceAccount:{emailid}', 'group:{emailid}', 'domain:{domain}' or using a federated principal."
  default     = []

  validation {
    condition     = alltrue([for m in var.members : can(regex("^(user|serviceAccount|group|domain|computed|principal|principalSet):(.+)", m))])
    error_message = "The value must be a non-empty list of strings where each entry is a valid principal type identified with a prefix such as e.g., `user:`, `serviceAccount:`, `group:`, `domain:`, `computed:`, `principal:` or `principalSet:."
  }
}

variable "computed_members_map" {
  type        = map(string)
  description = "(Optional) A map of members to replace in 'var.members' or in members of 'policy_bindings' to handle terraform computed values."
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.computed_members_map : can(regex("^(user|serviceAccount|group|domain):", v))])
    error_message = "The value must be a non-empty string being a valid principal type prefixed with `user:`, `serviceAccount:`, `group:` or `domain:`."
  }
}

variable "authoritative" {
  type        = bool
  description = "(Optional) Whether to exclusively set (authoritative mode) or add (non-authoritative/additive mode) members to the role."
  default     = false
}

variable "condition" {
  type        = any
  description = "(Optional) An IAM Condition for a given binding."
  default     = null
}

variable "policy_bindings" {
  type        = any
  description = "(Optional) A list of IAM policy bindings."
  default     = null
}

variable "audit_configs" {
  type        = any
  description = "(Optional) A list of Audit Logs configurations."
  default     = []
}

# ------------------------------------------------------------------------------
# MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# ------------------------------------------------------------------------------

variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether to create resources within the module or not. Default is 'true'."
  default     = true
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends_on. Default is '[]'."
  default     = []
}
