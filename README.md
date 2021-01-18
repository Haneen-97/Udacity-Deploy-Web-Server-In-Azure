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
- Please make sure to change variables in `variables.tf` to your preferences as well as packer template `server.json` change "managed_image_resource_group_name" to your existing resource group.
- Open azure cli and login to your account
  `az login`
  
- Create Tagging Security Policy using template using the command below<br>
  - `az policy definition create --name tagging-policy --mode indexed --rules tagging-policy.json`<br>
![tagging-policy](https://user-images.githubusercontent.com/43758373/104855342-4024a880-591d-11eb-9d4e-e68183689716.PNG)

- Run the following command to see assigned polices:
  `az policy assignment list`<br>
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
        A sample of the output:
```

# azurerm_availability_set.main:
+ resource "azurerm_availability_set" "main" {
    + id                           = "(known after apply)"
    + location                     = "uksouth"
    + managed                      = true
    + name                         = "udacity-azure-aset"
    + platform_fault_domain_count  = 2
    + platform_update_domain_count = 5
    + resource_group_name          = "udacity-azure-rg"
    + tags                         = {
        + "environment" = "test"
    }
}
```

screenshot:
![terraform-apply](https://user-images.githubusercontent.com/43758373/104944104-c269a700-59c7-11eb-9f66-3a49628f1272.PNG)


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

