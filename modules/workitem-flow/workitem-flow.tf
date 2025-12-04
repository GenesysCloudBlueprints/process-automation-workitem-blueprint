
resource "genesyscloud_flow" "workitem_flow" {
  filepath = "${path.module}/WorkitemFlow.yaml"
  substitutions = {
    workitemflow_name           = "${var.prefix_name} Workitem Flow ${var.environment_name}"
    division                    = var.division
    default_language            = "en-us"
    worktype_name               = var.worktype_name
    insurance_claim_queue_name  = var.insurance_claim_queue_name
    customer_service_queue_name = var.customer_service_queue_name
  }
}
