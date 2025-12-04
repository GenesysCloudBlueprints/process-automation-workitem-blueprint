variable "prefix_name" {
  type        = string
  description = "Workitem Flow Name Prefix"
}

variable "environment_name" {
  type        = string
  description = "Environment Name to be used in resource names"
}

variable "division" {
  type        = string
  description = "Name of the Division where the flow will be associated"
}

variable "worktype_name" {
  type        = string
  description = "Name of the worktype that will be associated to the created workitem"
}

variable "insurance_claim_queue_name" {
  type        = string
  description = "Name of the Insurance Claim routing queue"
}

variable "customer_service_queue_name" {
  type        = string
  description = "Name of the Customer Service routing queue"
}

