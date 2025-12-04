resource "genesyscloud_task_management_workbin" "insurance_claim_workbin" {
  name        = "${var.prefix_name} Workbin ${var.environment_name}"
  description = "${var.prefix_name} Workbin"
  division_id = var.genesys_division_id
}

resource "genesyscloud_task_management_workitem_schema" "insurance_claim_schema" {
  enabled = true
  name    = "${var.prefix_name} Schema ${var.environment_name}"
  properties = jsonencode({
    "claim_description_longtext" = {
      "allOf" = [
        {
          "$ref" = "#/definitions/longtext"
        }
      ],
      "maxLength" = 1000,
      "minLength" = 0,
      "title"     = "Claim Description"
    },
    "info_complete_checkbox" = {
      "allOf" = [
        {
          "$ref" = "#/definitions/checkbox"
        }
      ],
      "title" = "Info Complete"
    },
    "claim_id_identifier" : {
      "allOf" : [
        {
          "$ref" : "#/definitions/identifier"
        }
      ],
      "title" : "claim id",
      "description" : "claim identifier",
      "minLength" : 0,
      "maxLength" : 100
    },
    "insurance_type_enum" = {
      "_enumProperties" = {
        "car" = {
          "_disabled" = false,
          "title"     = "Car"
        },
        "contents" = {
          "_disabled" = false,
          "title"     = "Contents"
        },
        "home" = {
          "_disabled" = false,
          "title"     = "Home"
        },
        "pet" = {
          "_disabled" = false,
          "title"     = "Pet"
        }
      },
      "allOf" = [
        {
          "$ref" = "#/definitions/enum"
        }
      ],
      "enum" = [
        "home",
        "car",
        "pet",
        "contents"
      ],
      "title" = "Insurance Type"
    }
  })
}

# Available definitions for workitem schema properties:
# {
#     "custom_attribute_1_text" : {
#         "allOf" : [
#         {
#             "$ref" : "#/definitions/text"
#         }
#         ],
#         "title" : "custom_attribute_1",
#         "description" : "Custom attribute for text",
#         "minLength" : 0,
#         "maxLength" : 100
#     },
#     "custom_attribute_2_longtext" : {
#         "allOf" : [
#         {
#             "$ref" : "#/definitions/longtext"
#         }
#         ],
#         "title" : "custom_attribute_2",
#         "description" : "Custom attribute for long text",
#         "minLength" : 0,
#         "maxLength" : 1000
#     },
#     "custom_attribute_3_url" : {
#         "allOf" : [
#         {
#             "$ref" : "#/definitions/url"
#         }
#         ],
#         "title" : "custom_attribute_3",
#         "description" : "Custom attribute for url",
#         "minLength" : 0,
#         "maxLength" : 200
#     },
#     "custom_attribute_4_identifier" : {
#         "allOf" : [
#         {
#             "$ref" : "#/definitions/identifier"
#         }
#         ],
#         "title" : "custom_attribute_4",
#         "description" : "Custom attribute for identifier",
#         "minLength" : 0,
#         "maxLength" : 100
#     },
#     "custom_attribute_5_enum" : {
#         "allOf" : [
#         {
#             "$ref" : "#/definitions/enum"
#         }
#         ],
#         "title" : "custom_attribute_5",
#         "description" : "Custom attribute for enum",
#         "enum" : ["option_1", "option_2", "option_3"],
#         "_enumProperties" : {
#         "option_1" : {
#             "title" : "Option 1",
#             "_disabled" : false
#         },
#         "option_2" : {
#             "title" : "Option 2",
#             "_disabled" : false
#         },
#         "option_3" : {
#             "title" : "Option 3",
#             "_disabled" : false
#         },
#         },
#     },
#     "custom_attribute_6_date" : {
#         "allOf" : [
#         {
#             "$ref" : "#/definitions/date"
#         }
#         ],
#         "title" : "custom_attribute_6",
#         "description" : "Custom attribute for date",
#     },
#     "custom_attribute_7_datetime" : {
#         "allOf" : [
#         {
#             "$ref" : "#/definitions/datetime"
#         }
#         ],
#         "title" : "custom_attribute_7",
#         "description" : "Custom attribute for datetime",
#     },
#     "custom_attribute_8_integer" : {
#         "allOf" : [
#         {
#             "$ref" : "#/definitions/integer"
#         }
#         ],
#         "title" : "custom_attribute_8",
#         "description" : "Custom attribute for integer",
#         "minimum" : 1,
#         "maximum" : 1000
#     },
#     "custom_attribute_9_number" : {
#         "allOf" : [
#         {
#             "$ref" : "#/definitions/number"
#         }
#         ],
#         "title" : "custom_attribute_9",
#         "description" : "Custom attribute for number",
#         "minimum" : 1,
#         "maximum" : 1000
#     },
#     "custom_attribute_10_checkbox" : {
#         "allOf" : [
#         {
#             "$ref" : "#/definitions/checkbox"
#         }
#         ],
#         "title" : "custom_attribute_10",
#         "description" : "Custom attribute for checkbox"
#     },
#     "custom_attribute_11_tag" : {
#         "allOf" : [
#         {
#             "$ref" : "#/definitions/tag"
#         }
#         ],
#         "title" : "custom_attribute_11",
#         "description" : "Custom attribute for tag",
#         "items" : {
#         "minLength" : 1,
#         "maxLength" : 100
#         },
#         "minItems" : 0,
#         "maxItems" : 10,
#         "uniqueItems" : true
#     },
# }

resource "genesyscloud_task_management_worktype" "insurance_claim_worktype" {
  name               = "${var.prefix_name} Worktype ${var.environment_name}"
  assignment_enabled = true

  schema_id          = genesyscloud_task_management_workitem_schema.insurance_claim_schema.id
  default_queue_id   = var.insurance_claim_queue_id
  default_workbin_id = genesyscloud_task_management_workbin.insurance_claim_workbin.id
  division_id        = var.genesys_division_id

  default_due_duration_seconds = 1296000
  default_duration_seconds     = 604800
  default_expiration_seconds   = 2592000
  default_priority             = 2000
  default_ttl_seconds          = 2678400
}

## Worktype Statuses

resource "genesyscloud_task_management_worktype_status" "open_status" {
  depends_on  = [genesyscloud_task_management_worktype.insurance_claim_worktype]
  worktype_id = genesyscloud_task_management_worktype.insurance_claim_worktype.id
  name        = "Open Status"
  description = "Status for newly created insurance claim workitems"
  category    = "Open"
  default     = true
}

resource "genesyscloud_task_management_worktype_status" "verify_information_status" {
  depends_on  = [genesyscloud_task_management_worktype.insurance_claim_worktype]
  worktype_id = genesyscloud_task_management_worktype.insurance_claim_worktype.id
  name        = "Verify Information"
  description = "Status for workitems pending information verification"
  category    = "InProgress"
  default     = false
}

resource "genesyscloud_task_management_worktype_status" "gather_information_status" {
  depends_on  = [genesyscloud_task_management_worktype.insurance_claim_worktype]
  worktype_id = genesyscloud_task_management_worktype.insurance_claim_worktype.id
  name        = "Gather Information"
  description = "Status for workitems requiring information gathering"
  category    = "InProgress"
  default     = false
}

resource "genesyscloud_task_management_worktype_status" "analyze_claim_status" {
  depends_on  = [genesyscloud_task_management_worktype.insurance_claim_worktype]
  worktype_id = genesyscloud_task_management_worktype.insurance_claim_worktype.id
  name        = "Analyze Claim"
  description = "Status for workitems with analyzing claim"
  category    = "InProgress"
  default     = false
}

resource "genesyscloud_task_management_worktype_status" "approved_status" {
  depends_on  = [genesyscloud_task_management_worktype.insurance_claim_worktype]
  worktype_id = genesyscloud_task_management_worktype.insurance_claim_worktype.id
  name        = "Approved"
  description = "Status for workitems that have been approved"
  category    = "Closed"
  default     = false
}

resource "genesyscloud_task_management_worktype_status" "rejected_status" {
  depends_on  = [genesyscloud_task_management_worktype.insurance_claim_worktype]
  worktype_id = genesyscloud_task_management_worktype.insurance_claim_worktype.id
  name        = "Rejected"
  description = "Status for workitems that have been rejected"
  category    = "Closed"
  default     = false
}

## Worktype Status Transitions
## As of December 2025, destroying/editing transitions might occur a 409 error. You can retry to resolve.

resource "genesyscloud_task_management_worktype_status_transition" "open_transition" {
  depends_on                      = [genesyscloud_task_management_worktype.insurance_claim_worktype, genesyscloud_task_management_worktype_status.verify_information_status, genesyscloud_task_management_worktype_status.open_status]
  worktype_id                     = genesyscloud_task_management_worktype.insurance_claim_worktype.id
  status_id                       = genesyscloud_task_management_worktype_status.open_status.id
  destination_status_ids          = [genesyscloud_task_management_worktype_status.verify_information_status.id]
  default_destination_status_id   = genesyscloud_task_management_worktype_status.verify_information_status.id
  status_transition_delay_seconds = 60
}

resource "genesyscloud_task_management_worktype_status_transition" "verify_information_transition" {
  depends_on             = [genesyscloud_task_management_worktype.insurance_claim_worktype, genesyscloud_task_management_worktype_status.verify_information_status, genesyscloud_task_management_worktype_status.gather_information_status, genesyscloud_task_management_worktype_status.analyze_claim_status]
  worktype_id            = genesyscloud_task_management_worktype.insurance_claim_worktype.id
  status_id              = genesyscloud_task_management_worktype_status.verify_information_status.id
  destination_status_ids = [genesyscloud_task_management_worktype_status.gather_information_status.id, genesyscloud_task_management_worktype_status.analyze_claim_status.id]
}

resource "genesyscloud_task_management_worktype_status_transition" "gather_information_transition" {
  depends_on                      = [genesyscloud_task_management_worktype.insurance_claim_worktype, genesyscloud_task_management_worktype_status.verify_information_status, genesyscloud_task_management_worktype_status.gather_information_status, genesyscloud_task_management_worktype_status.analyze_claim_status]
  worktype_id                     = genesyscloud_task_management_worktype.insurance_claim_worktype.id
  status_id                       = genesyscloud_task_management_worktype_status.gather_information_status.id
  destination_status_ids          = [genesyscloud_task_management_worktype_status.verify_information_status.id, genesyscloud_task_management_worktype_status.analyze_claim_status.id]
  default_destination_status_id   = genesyscloud_task_management_worktype_status.verify_information_status.id
  status_transition_delay_seconds = 60
}

resource "genesyscloud_task_management_worktype_status_transition" "analyze_claim_transition" {
  depends_on                      = [genesyscloud_task_management_worktype.insurance_claim_worktype, genesyscloud_task_management_worktype_status.approved_status, genesyscloud_task_management_worktype_status.rejected_status, genesyscloud_task_management_worktype_status.analyze_claim_status]
  worktype_id                     = genesyscloud_task_management_worktype.insurance_claim_worktype.id
  status_id                       = genesyscloud_task_management_worktype_status.analyze_claim_status.id
  destination_status_ids          = [genesyscloud_task_management_worktype_status.approved_status.id, genesyscloud_task_management_worktype_status.rejected_status.id]
  default_destination_status_id   = genesyscloud_task_management_worktype_status.approved_status.id
  status_transition_delay_seconds = 60
}

## Worktype Rules

resource "genesyscloud_task_management_worktype_flow_onattributechange_rule" "verify_information_rule" {
  depends_on  = [genesyscloud_task_management_worktype.insurance_claim_worktype, genesyscloud_task_management_worktype_status.verify_information_status, genesyscloud_task_management_worktype_status.gather_information_status]
  worktype_id = genesyscloud_task_management_worktype.insurance_claim_worktype.id
  name        = "Verify Information Rule"
  condition {
    attribute = "statusId"
    old_value = genesyscloud_task_management_worktype_status.gather_information_status.id
    new_value = genesyscloud_task_management_worktype_status.verify_information_status.id
  }
}

resource "genesyscloud_task_management_worktype_flow_onattributechange_rule" "gather_information_rule" {
  depends_on  = [genesyscloud_task_management_worktype.insurance_claim_worktype, genesyscloud_task_management_worktype_status.gather_information_status]
  worktype_id = genesyscloud_task_management_worktype.insurance_claim_worktype.id
  name        = "Gather Information Rule"
  condition {
    attribute = "statusId"
    new_value = genesyscloud_task_management_worktype_status.gather_information_status.id
  }
}

resource "genesyscloud_task_management_worktype_flow_onattributechange_rule" "analyze_claim_rule" {
  depends_on  = [genesyscloud_task_management_worktype.insurance_claim_worktype, genesyscloud_task_management_worktype_status.analyze_claim_status]
  worktype_id = genesyscloud_task_management_worktype.insurance_claim_worktype.id
  name        = "Analyze Claim Rule"
  condition {
    attribute = "statusId"
    new_value = genesyscloud_task_management_worktype_status.analyze_claim_status.id
  }
}

## Other Worktype Rules
# resource "genesyscloud_task_management_worktype_flow_datebased_rule" "datebased_rule" {
#   worktype_id = genesyscloud_task_management_worktype.example_worktype.id
#   name        = "DateBased Rule"
#   condition {
#     attribute                      = "dateDue"
#     relative_minutes_to_invocation = -10
#   }
# }

# resource "genesyscloud_task_management_worktype_flow_oncreate_rule" "oncreate_rule" {
#   worktype_id = genesyscloud_task_management_worktype.example_worktype_without_assignment.id
#   name        = "OnCreate Rule"
# }
