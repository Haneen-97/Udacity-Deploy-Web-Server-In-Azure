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


- To build the packer image you must output your azure credentials:
  -Create Azure credentials:
  `az ad sp create-for-rbac --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"`
  An example of the output from the preceding commands is as follows:

`{
    "client_id": "f5b6a5cf-fbdf-4a9f-b3b8-3c2cd00225a4",
    "client_secret": "0e760437-bf34-4aad-9f8d-870be799c55d",
    "tenant_id": "72f988bf-86f1-41af-91ab-2d7cd011db47"
}`

*For more detials please visit [How to use Packer to create Linux virtual machine images in Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/build-image-with-packer) 

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
![terraform-apply](https://user-images.githubusercontent.com/43758373/104918146-63933600-59a5-11eb-8e2b-cd7842a7b8e7.PNG)


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

