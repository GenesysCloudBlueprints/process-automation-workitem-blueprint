variable "prefix_name" {
  type        = string
  description = "General Prefix Name for Resources"
}

variable "environment_name" {
  type        = string
  description = "The affix that will be added to resources to determine its environment."
  default     = "Dev"
}

variable "genesys_division_id" {
  description = "The id of the Genesys Cloud division where you want to deploy the bot and flow."
  type        = string
}

variable "insurance_claim_queue_id" {
  type        = string
  description = "ID of the Insurance Claim routing queue"
}
