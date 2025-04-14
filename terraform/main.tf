terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~>2.3"
    }
  }
  backend azurerm {
    
  }
}

provider azurerm {
  subscription_id = var.subscription_id
  features {}
}

provider azapi {
  subscription_id = var.subscription_id
}

provider azurerm {
  alias = "hub"
  subscription_id = var.hub_subscription_id
  features {}
}

data azurerm_client_config current {

}

resource azurerm_resource_group platform {
  name = "rg-${var.default_name}"
  tags = var.default_tags
  location = var.metadata_location

  lifecycle {
    ignore_changes = [ tags ]
    prevent_destroy = true
  }
}
