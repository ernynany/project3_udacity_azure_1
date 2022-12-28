provider "azurerm" {
  tenant_id       = "${var.tenant_id}"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  features {}
}

# key below is the name of the state file to be created, while access_key is the storage access key
terraform {
  backend "azurerm" {
    storage_account_name = "tfstate29341"
    container_name       = "tfstate"
    key                  = "test.terraform.tfstate"
    access_key           = "DR5wOYgOvCI5mH0W05BeuXMR/eBYExNFJ6sgHfklvhy9gRnyoWreSUHswW3mg8tneaOLBkSod8/h+AStRuIKQA=="
  }
}

# since we already have an existing resource group which we have indicated on the .tfvars file. We only need to reference that resource group instead of creating a new one
# module "resource_group" {
#  source               = "../../modules/resource_group"
#  name       = "project3_quality_release"
#  location             = "${var.location}"
#}

# Resource group
data "azurerm_resource_group" "test" {
  name = "project3_quality_release"
}

#output "id" {
#  value = data.azurerm_resource_group.test.id
#}

module "network" {
  source               = "../../modules/network"
  address_space        = "${var.address_space}"
  location             = "${var.location}"
  virtual_network_name = "${var.virtual_network_name}"
  application_type     = "${var.application_type}"
  resource_type        = "NET"
  resource_group       = "${data.azurerm_resource_group.test.name}"
  address_prefix_test  = "${var.address_prefix_test}"
}



# address_prefixes     = ["${var.address_prefix_test}"]


module "nsg-test" {
  source           = "../../modules/networksecuritygroup"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "NSG"
  resource_group   = "${data.azurerm_resource_group.test.name}"
  subnet_id        = "${module.network.subnet_id_test}"
  address_prefix_test = "${var.address_prefix_test}"
}
module "appservice" {
  source           = "../../modules/appservice"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "AppService"
  resource_group   = "${data.azurerm_resource_group.test.name}"
}
module "publicip" {
  source           = "../../modules/publicip"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "publicip"
  resource_group   = "${data.azurerm_resource_group.test.name}"
}

module "vm" {
  source           = "../../modules/vm"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "VM"
  resource_group   = "${data.azurerm_resource_group.test.name}"
  subnet_id        = "${module.network.subnet_id_test}"
  public_ip        = "${module.publicip.public_ip_address_id}"
}