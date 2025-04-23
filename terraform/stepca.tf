data smallstep_authority ca {
  id = var.stepca_uuid
}

data smallstep_provisioner jwk {
  authority_id = data.smallstep_authority.ca.id
  name = var.default_name
}

locals {
  stepca_replicas = 1
}

module stepca {
  source = "../../awg-appdev-modules/terraform/stepca"
  name = var.default_name
  tags = var.default_tags
  resource_group = azurerm_resource_group.platform
  location = var.resource_location
  subnet = azurerm_subnet.default
  replicas = local.stepca_replicas
  admin_username = "sysadmin"
  admin_password = base64decode("SjY4TnhTOUcyUXhHczBHNyE=")
  ca_url = "https://${data.smallstep_authority.ca.domain}/"
  ca_fingerprint = data.smallstep_authority.ca.fingerprint
  ca_provisioner_name = data.smallstep_provisioner.jwk.name
  ca_provisioner_password = var.stepca_provisioner_password
  dns_names = [ "ca.${azurerm_private_dns_zone.internal.name}" ]
}

resource azurerm_private_dns_cname_record stepca {
  count = local.stepca_replicas

  name = "ca"
  tags = var.default_tags
  resource_group_name = azurerm_resource_group.platform.name
  
  zone_name = azurerm_private_dns_zone.internal.name
  record = "${var.default_name}-stepca-${count.index}.${azurerm_private_dns_zone.internal.name}"
  ttl = 300

  lifecycle {
    ignore_changes = [ tags ]
  }
}
