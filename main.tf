data "genesyscloud_auth_division" "division_data" {
  name = var.genesys_division_name
}

resource "genesyscloud_routing_queue" "insurance_claim_queue" {
  name                     = "Insurance Claim ${var.environment_name}"
  enable_manual_assignment = true
}

resource "genesyscloud_routing_queue" "customer_service_queue" {
  name                     = "Customer Service ${var.environment_name}"
  enable_manual_assignment = true
}

module "workitem_elements" {
  depends_on               = [data.genesyscloud_auth_division.division_data]
  source                   = "./modules/workitem-elements"
  prefix_name              = "Insurance Claim Blueprint"
  environment_name         = var.environment_name
  genesys_division_id      = data.genesyscloud_auth_division.division_data.id
  insurance_claim_queue_id = genesyscloud_routing_queue.insurance_claim_queue.id
}

module "workitem_flow" {
  depends_on                  = [module.workitem_elements, data.genesyscloud_auth_division.division_data, genesyscloud_routing_queue.customer_service_queue, genesyscloud_routing_queue.insurance_claim_queue]
  source                      = "./modules/workitem-flow"
  prefix_name                 = "Insurance Claim Blueprint"
  environment_name            = var.environment_name
  division                    = var.genesys_division_name
  worktype_name               = module.workitem_elements.worktype_name
  insurance_claim_queue_name  = genesyscloud_routing_queue.insurance_claim_queue.name
  customer_service_queue_name = genesyscloud_routing_queue.customer_service_queue.name
}
