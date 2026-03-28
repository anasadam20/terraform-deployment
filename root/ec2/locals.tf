locals {
  # Define tag sets for each application
  app_tags = {
    teamfirst = {
      Name                  = "teamfirst1"
      project               = "DAL"
      platform              = "aws"
      environment-type      = var.environment
      application-team      = "TeamFirstOps"
      technical-team        = "CloudOps@bcbsma.com"
      service-type          = "dedicate"
      phi-data              = lower(var.environment) == "prod" ? "true" : "false"
      tier                  = "private"
      terraform-managed     = "true"
      PatchGroup            = "WEEK2_SUN_7AM_NONPROD"
      tenable-agent         = "amazonlinux"
    }

    teamsecond = {
      Name                  = "teamsecond2"
      project               = "DAL"
      platform              = "aws"
      environment-type      = var.environment
      application-team      = "TeamSecondOps"
      technical-team        = "CloudOps@bcbsma.com"
      service-type          = "dedicate"
      phi-data              = lower(var.environment) == "prod" ? "true" : "false"
      tier                  = "private"
      terraform-managed     = "true"
      PatchGroup            = "WEEK4_SUN_7AM_PROD"
      tenable-agent         = "amazonlinux"
    }
  }

  # Select the tag set based on app_name
  selected_tags = lookup(local.app_tags, var.app_name, {})
}
