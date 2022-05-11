# Bicep Modern Data Platform Infrastructure Example

![Visualisation of Bicep output from VSCode Extension, showing all services defined on a canvas. Services are Data Factory, Data Lake Storage, Azure Synapse, and Azure Key Vault.](/img/1.png)

Repo for initial implementation of bicep templates for generic MDW pattern in Azure.

## util

Getting started/useful cli commands (to go in .ado pipelines). The below command will deploy the infrastructure into your environment:

- `az deployment sub create -f ./iac/bicep/main.bicep -l northeurope -c --parameters env='dev' p='SuperSecurePassw0rd$' project='projname' tenantId='AAD Tenant ID'`

## todo

Variable for Synapse workspace AAD object ID
add Managed Identity for adf and workspace to the key vault access policies