variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "labcat"
}

variable "environment" {
  description = "Environment name (e.g., uat, production)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "australiaeast"
}
