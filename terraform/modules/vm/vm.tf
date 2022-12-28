resource "azurerm_network_interface" "test" {
  name                = "${var.application_type}-${var.resource_type}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${var.public_ip}"
  }
}

resource "azurerm_linux_virtual_machine" "test" {
  name                = "${var.application_type}-${var.resource_type}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
  size                = "Standard_D2_v3"
  admin_username      = "nosa"
  network_interface_ids = [azurerm_network_interface.test.id]
  admin_ssh_key {
    username   = "nosa"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZRVO+luCt9AtNahIt6pzXqL9YZmjkeJDnzMN2KDV1kKa1Uhm1MDhnX9wMIAqyZQ9iTEA2GuLd7NgdwMAyWXsX3PQghsgYibsnKNthCntG+3LdrIE6akNG2X2mrWWNLtYyIKKpfT8hu9c71awjOAWBAB03QxiTw7QBT2eaIXSI9bvqvERTDWUBgGmPBb/bjjFb+IsHigNm+RH0zx7WF5nwTznm29fCcKaj+kqkFUsNGrGjAe1o1qXzKVASjW+URMoZbnz18YXb8geAL3GK7/o7E0cAVyNbzJwPlGN6/+9lIddKxz1wCQc3C36r/X8jMSywklxjLU5B+sBi/2Zu2BmsruBz3M9JLuFW/IXrpuBOeieg+OkTWUc8y5fKaqgtFkC8celDCFdI1tnk/f96uxV4msUZhfyekMhAF9y514TBIb+kC2mJKSvAhWJ+fKUAhg1E6mDg2+X1MtbEt6zYSJMuaFlSjbeY8LfPqC35nbc+2cu9Uvizc8049AbzvEvEDV8= nosa-ubuntu@DESKTOP-ND8EM2D"
  }
  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
