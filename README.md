# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

2. Ensure you have all dependencies installed and Microsoft accounts (see Dependencies section)

3. Run commands to create resources (see Instructions section for commands).

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
- Open azure cli and login to your account
  `az login`
  
- Create Tagging Security Policy using template using the command below<br>
  - `az policy definition create --name tagging-policy --mode indexed --rules tagging-policy.json`<br>
![tagging-policy](https://user-images.githubusercontent.com/43758373/104855342-4024a880-591d-11eb-9d4e-e68183689716.PNG)

- Run the following command to see assigned polices:
  `az policy assignment list`
 ![assignment-list](https://user-images.githubusercontent.com/43758373/104916985-da2f3400-59a3-11eb-81dd-4797c273aaa7.PNG)


- To build the packer image you must output your azure credentials:<br>
    - Create Azure credentials:<br>
  `az ad sp create-for-rbac --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"`<br>
  An example of the output from the preceding commands is as follows:<br>

  ![xx](https://user-images.githubusercontent.com/43758373/104918378-b66ced80-59a5-11eb-9b61-0cafeb32bb8d.PNG)


*For more detials please visit [How to use Packer to create Linux virtual machine images in Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/build-image-with-packer)*

- Deploy the server image
  - `packer build server.json`<br/>
    An example of the output:
    ![packer-build](https://user-images.githubusercontent.com/43758373/104904477-4012c000-5992-11eb-9dcc-ffbc90f332f9.PNG)

- Deploy resources to Azure using `main.tf`
  1. terraform initialization:
    - `terraform init`<br/>
        An example of the output:
        ![terraform-init](https://user-images.githubusercontent.com/43758373/104913157-4313ad80-599e-11eb-98f6-c881b389f942.PNG)

  2. create plan
    - `terraform plan -out solution.plan`<br/>
        An example of the output:
        ![terraform-plan](https://user-images.githubusercontent.com/43758373/104913980-7a368e80-599f-11eb-8051-8f2308d13113.PNG)
  
  3. apply plan
    - `terraform apply`<br/>
        An example of the output:
          ```
          # azurerm_availability_set.main:
resource "azurerm_availability_set" "main" {
    id                           = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Compute/availabilitySets/udacity-azure-aset"
    location                     = "uksouth"
    managed                      = true
    name                         = "udacity-azure-aset"
    platform_fault_domain_count  = 2
    platform_update_domain_count = 5
    resource_group_name          = "udacity-azure-rg"
    tags                         = {
        "environment" = "test"
    }
}

# azurerm_lb.main:
resource "azurerm_lb" "main" {
    id                   = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Network/loadBalancers/udacity-azure-lb"
    location             = "uksouth"
    name                 = "udacity-azure-lb"
    private_ip_addresses = []
    resource_group_name  = "udacity-azure-rg"
    sku                  = "Basic"
    tags                 = {
        "environment" = "test"
    }

    frontend_ip_configuration {
        id                            = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Network/loadBalancers/udacity-azure-lb/frontendIPConfigurations/PublicIPAddress"
        inbound_nat_rules             = []
        load_balancer_rules           = []
        name                          = "PublicIPAddress"
        outbound_rules                = []
        private_ip_address_allocation = "Dynamic"
        private_ip_address_version    = "IPv4"
        public_ip_address_id          = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Network/publicIPAddresses/udacity-azure-publicIp"
        zones                         = []
    }
}

# azurerm_lb_backend_address_pool.main:
resource "azurerm_lb_backend_address_pool" "main" {
    backend_ip_configurations = [
        "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Network/networkInterfaces/udacity-azure-nic-int/ipConfigurations/testConfiguration",
        "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Network/networkInterfaces/udacity-azure-nic-uat/ipConfigurations/testConfiguration",
    ]
    id                        = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Network/loadBalancers/udacity-azure-lb/backendAddressPools/BackEndAddressPool"
    load_balancing_rules      = []
    loadbalancer_id           = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Network/loadBalancers/udacity-azure-lb"
    name                      = "BackEndAddressPool"
    resource_group_name       = "udacity-azure-rg"
}

# azurerm_linux_virtual_machine.main[0]:
resource "azurerm_linux_virtual_machine" "main" {
    admin_password                  = (sensitive value)
    admin_username                  = "username"
    allow_extension_operations      = true
    availability_set_id             = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Compute/availabilitySets/UDACITY-AZURE-ASET"
    computer_name                   = "udacity-azure-vm-uat"
    disable_password_authentication = false
    encryption_at_host_enabled      = false
    extensions_time_budget          = "PT1H30M"
    id                              = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Compute/virtualMachines/udacity-azure-vm-uat"
    location                        = "uksouth"
    max_bid_price                   = -1
    name                            = "udacity-azure-vm-uat"
    network_interface_ids           = [
        "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Network/networkInterfaces/udacity-azure-nic-uat",
    ]
    priority                        = "Regular"
    private_ip_address              = "10.0.0.5"
    private_ip_addresses            = [
        "10.0.0.5",
    ]
    provision_vm_agent              = true
    public_ip_addresses             = []
    resource_group_name             = "udacity-azure-rg"
    size                            = "Standard_D2s_v3"
    source_image_id                 = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/packer-rg/providers/Microsoft.Compute/images/udacityPackerImage"
    tags                            = {
        "environment" = "test"
        "name"        = "uat"
    }
    virtual_machine_id              = "676f2dc3-6eac-4a19-a94e-7fa92a610318"

    os_disk {
        caching                   = "ReadWrite"
        disk_size_gb              = 30
        name                      = "udacity-azure-vm-uat_disk1_afe3105508804746ab485a0c77c536e3"
        storage_account_type      = "Standard_LRS"
        write_accelerator_enabled = false
    }
}

# azurerm_linux_virtual_machine.main[1]:
resource "azurerm_linux_virtual_machine" "main" {
    admin_password                  = (sensitive value)
    admin_username                  = "username"
    allow_extension_operations      = true
    availability_set_id             = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Compute/availabilitySets/UDACITY-AZURE-ASET"
    computer_name                   = "udacity-azure-vm-int"
    disable_password_authentication = false
    encryption_at_host_enabled      = false
    extensions_time_budget          = "PT1H30M"
    id                              = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Compute/virtualMachines/udacity-azure-vm-int"
    location                        = "uksouth"
    max_bid_price                   = -1
    name                            = "udacity-azure-vm-int"
    network_interface_ids           = [
        "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Network/networkInterfaces/udacity-azure-nic-int",
    ]
    priority                        = "Regular"
    private_ip_address              = "10.0.0.4"
    private_ip_addresses            = [
        "10.0.0.4",
    ]
    provision_vm_agent              = true
    public_ip_addresses             = []
    resource_group_name             = "udacity-azure-rg"
    size                            = "Standard_D2s_v3"
    source_image_id                 = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/packer-rg/providers/Microsoft.Compute/images/udacityPackerImage"
    tags                            = {
        "environment" = "test"
        "name"        = "int"
    }
    virtual_machine_id              = "524f605f-7009-4f72-9488-68d3fcb430ee"

    os_disk {
        caching                   = "ReadWrite"
        disk_size_gb              = 30
        name                      = "udacity-azure-vm-int_disk1_9fcdceb030d0459c8a333ba2f80c29ca"
        storage_account_type      = "Standard_LRS"
        write_accelerator_enabled = false
    }
}

# azurerm_managed_disk.main:
resource "azurerm_managed_disk" "main" {
    create_option        = "Empty"
    disk_iops_read_write = 500
    disk_mbps_read_write = 60
    disk_size_gb         = 1
    id                   = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Compute/disks/udacity-azure-md"
    location             = "uksouth"
    name                 = "udacity-azure-md"
    resource_group_name  = "udacity-azure-rg"
    storage_account_type = "Standard_LRS"
    tags                 = {
        "environment" = "test"
    }
    zones                = []
}

# azurerm_network_interface.main[0]:
resource "azurerm_network_interface" "main" {
    applied_dns_servers           = []
    dns_servers                   = []
    enable_accelerated_networking = false
    enable_ip_forwarding          = false
    id                            = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Network/networkInterfaces/udacity-azure-nic-uat"
    internal_domain_name_suffix   = "kgggqk4l3zzevn2f03kj5pqfsh.zx.internal.cloudapp.net"
    location                      = "uksouth"
    mac_address                   = "00-22-48-40-11-1A"
    name                          = "udacity-azure-nic-uat"
    private_ip_address            = "10.0.0.5"
    private_ip_addresses          = [
        "10.0.0.5",
    ]
    resource_group_name           = "udacity-azure-rg"
    tags                          = {
        "environment" = "test"
    }
    virtual_machine_id            = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Compute/virtualMachines/udacity-azure-vm-uat"

    ip_configuration {
        name                          = "testConfiguration"
        primary                       = true
        private_ip_address            = "10.0.0.5"
        private_ip_address_allocation = "Dynamic"
        private_ip_address_version    = "IPv4"
        subnet_id                     = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Network/virtualNetworks/udacity-azure-network/subnets/udacity-azure-subnet"
    }
}

# azurerm_network_interface.main[1]:
resource "azurerm_network_interface" "main" {
    applied_dns_servers           = []
    dns_servers                   = []
    enable_accelerated_networking = false
    enable_ip_forwarding          = false
    id                            = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Network/networkInterfaces/udacity-azure-nic-int"
    internal_domain_name_suffix   = "kgggqk4l3zzevn2f03kj5pqfsh.zx.internal.cloudapp.net"
    location                      = "uksouth"
    mac_address                   = "00-22-48-40-17-2A"
    name                          = "udacity-azure-nic-int"
    private_ip_address            = "10.0.0.4"
    private_ip_addresses          = [
        "10.0.0.4",
    ]
    resource_group_name           = "udacity-azure-rg"
    tags                          = {
        "environment" = "test"
    }
    virtual_machine_id            = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Compute/virtualMachines/udacity-azure-vm-int"

    ip_configuration {
        name                          = "testConfiguration"
        primary                       = true
        private_ip_address            = "10.0.0.4"
        private_ip_address_allocation = "Dynamic"
        private_ip_address_version    = "IPv4"
        subnet_id                     = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Network/virtualNetworks/udacity-azure-network/subnets/udacity-azure-subnet"
    }
}

# azurerm_network_interface_backend_address_pool_association.main[0]:
resource "azurerm_network_interface_backend_address_pool_association" "main" {
    backend_address_pool_id = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Network/loadBalancers/udacity-azure-lb/backendAddressPools/BackEndAddressPool"
    id                      = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Network/networkInterfaces/udacity-azure-nic-uat/ipConfigurations/testConfiguration|/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Network/loadBalancers/udacity-azure-lb/backendAddressPools/BackEndAddressPool"
    ip_configuration_name   = "testConfiguration"
    network_interface_id    = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Network/networkInterfaces/udacity-azure-nic-uat"
}

# azurerm_network_interface_backend_address_pool_association.main[1]:
resource "azurerm_network_interface_backend_address_pool_association" "main" {
    backend_address_pool_id = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Network/loadBalancers/udacity-azure-lb/backendAddressPools/BackEndAddressPool"
    id                      = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Network/networkInterfaces/udacity-azure-nic-int/ipConfigurations/testConfiguration|/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Network/loadBalancers/udacity-azure-lb/backendAddressPools/BackEndAddressPool"
    ip_configuration_name   = "testConfiguration"
    network_interface_id    = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Network/networkInterfaces/udacity-azure-nic-int"
}

# azurerm_network_security_group.main:
resource "azurerm_network_security_group" "main" {
    id                  = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Network/networkSecurityGroups/udacity-azure-nsg"
    location            = "uksouth"
    name                = "udacity-azure-nsg"
    resource_group_name = "udacity-azure-rg"
    security_rule       = [
        {
            access                                     = "Allow"
            description                                = "Allow access to other VMs on the subnet"
            destination_address_prefix                 = "VirtualNetwork"
            destination_address_prefixes               = []
            destination_application_security_group_ids = []
            destination_port_range                     = "*"
            destination_port_ranges                    = []
            direction                                  = "Inbound"
            name                                       = "AllowVnetInBound"
            priority                                   = 101
            protocol                                   = "*"
            source_address_prefix                      = "VirtualNetwork"
            source_address_prefixes                    = []
            source_application_security_group_ids      = []
            source_port_range                          = "*"
            source_port_ranges                         = []
        },
        {
            access                                     = "Deny"
            description                                = "Deny all inbound traffic outside of the vnet from the Internet"
            destination_address_prefix                 = "VirtualNetwork"
            destination_address_prefixes               = []
            destination_application_security_group_ids = []
            destination_port_range                     = "*"
            destination_port_ranges                    = []
            direction                                  = "Inbound"
            name                                       = "DenyInternetInBound"
            priority                                   = 100
            protocol                                   = "*"
            source_address_prefix                      = "Internet"
            source_address_prefixes                    = []
            source_application_security_group_ids      = []
            source_port_range                          = "*"
            source_port_ranges                         = []
        },
    ]
    tags                = {
        "environment" = "test"
    }
}

# azurerm_public_ip.main:
resource "azurerm_public_ip" "main" {
    allocation_method       = "Static"
    id                      = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Network/publicIPAddresses/udacity-azure-publicIp"
    idle_timeout_in_minutes = 4
    ip_address              = "51.104.221.153"
    ip_version              = "IPv4"
    location                = "uksouth"
    name                    = "udacity-azure-publicIp"
    resource_group_name     = "udacity-azure-rg"
    sku                     = "Basic"
    tags                    = {
        "environment" = "test"
    }
    zones                   = []
}

# azurerm_resource_group.main:
resource "azurerm_resource_group" "main" {
    id       = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg"
    location = "uksouth"
    name     = "udacity-azure-rg"
    tags     = {}
}

# azurerm_subnet.main:
resource "azurerm_subnet" "main" {
    address_prefix                                 = "10.0.0.0/24"
    address_prefixes                               = [
        "10.0.0.0/24",
    ]
    enforce_private_link_endpoint_network_policies = false
    enforce_private_link_service_network_policies  = false
    id                                             = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Network/virtualNetworks/udacity-azure-network/subnets/udacity-azure-subnet"
    name                                           = "udacity-azure-subnet"
    resource_group_name                            = "udacity-azure-rg"
    service_endpoint_policy_ids                    = []
    service_endpoints                              = []
    virtual_network_name                           = "udacity-azure-network"
}

# azurerm_virtual_network.main:
resource "azurerm_virtual_network" "main" {
    address_space         = [
        "10.0.0.0/16",
    ]
    dns_servers           = []
    guid                  = "2b688c51-eecb-4a72-b785-d7549fbe0597"
    id                    = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Network/virtualNetworks/udacity-azure-network"
    location              = "uksouth"
    name                  = "udacity-azure-network"
    resource_group_name   = "udacity-azure-rg"
    subnet                = [
        {
            address_prefix = "10.0.0.0/24"
            id             = "/subscriptions/2422eebb-1624-4ca2-9112-7c1f90527a73/resourceGroups/udacity-azure-rg/providers/Microsoft.Network/virtualNetworks/udacity-azure-network/subnets/udacity-azure-subnet"
            name           = "udacity-azure-subnet"
            security_group = ""
        },
    ]
    tags                  = {
        "environment" = "test"
    }
    vm_protection_enabled = false
          ```


### Output
After apply command, if it is success it means that all resources are deployed in the azure server. 

run the following command:<br/>
```terraform show```

An example of the output:<br/>
![terraform-show](https://user-images.githubusercontent.com/43758373/104913154-41e28080-599e-11eb-9ef9-ea0f230721ca.PNG)

To make sure that the resources are deployed, you can go to azure portal and view all resources page. As shown below:

![resources](https://user-images.githubusercontent.com/43758373/104913415-9ab21900-599e-11eb-80c7-d000e20729cd.PNG)


After the deployment, remember to destroy the resources using terraform command.

``` bash
terraform destroy
```

