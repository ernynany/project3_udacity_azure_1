# Azure subscription vars
subscription_id = "3f8e074e-7d07-4990-8a18-bb4023ba8f4c"
client_id       = "f020d581-daf4-4473-b1de-c6af0ad31836"
client_secret   = "MYk8Q~GVc3G0~ZjyctMjOEiVIPImrcqgPimvGaQq"
tenant_id       = "2202583d-31dc-43c2-9798-c28c0ffe2a4f"

# Resource Group/Location
location            = "eastus"
resource_group = "project3_quality_release"
application_type    = "project3Application"

# Network
virtual_network_name = "project3-vNet"
address_space        = ["10.5.0.0/16"]
address_prefix_test  = "10.5.1.0/24"


# A .tfvars file is used to assign values to variables that have already been declared in .tf files, not to declare new variables. To declare variable "location", place this block in one of your .tf  
# files, such as variables.tf.
#│
#│ To set a value for this variable in terraform.tfvars, use the definition syntax instead:
#     location = <value>
