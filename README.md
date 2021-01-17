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
- Create Tagging Security Policy using template using the command below
  - `az policy definition create --name tagging-policy --mode indexed --rules tagging-policy.json`
![tagging-policy](https://user-images.githubusercontent.com/43758373/104855342-4024a880-591d-11eb-9d4e-e68183689716.PNG)

### Output
**Your words here**
