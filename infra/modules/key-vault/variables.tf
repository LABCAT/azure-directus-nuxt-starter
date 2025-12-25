variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "secrets" {
  description = "Map of secrets to store in Key Vault"
  type        = map(string)
  # sensitive   = true
}
