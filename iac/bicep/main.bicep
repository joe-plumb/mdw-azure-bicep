param location string = deployment().location
param env string
param project string
param p string
param tenantId string
param randomnum string

param tagValues object = {
}


targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'analytics-CLEOPoC-${env}-rg-${randomnum}'
  location: location
}

module adf 'adf.bicep' = {
  name: 'adfDeploy'
  scope: rg
  params: {
    env: env
    location: location
    tagValues: tagValues
    randomnum: randomnum
  }
}

module adls 'adls.bicep' = {
  name: 'adlsDeploy'
  scope: rg
  params: {
    env: env
    location: location
    project: project
    tagValues: tagValues
    randomnum: randomnum
  }
}

module synapse 'synapse.bicep' = {
  name: 'synapseDeploy'
  scope: rg
  params: {
    env: env
    location: location
    project: project
    accountUrl: adls.outputs.accountUrl
    accountResourceId: adls.outputs.accountResourceId
    p: p
    tagValues: tagValues
    randomnum: randomnum
  }
  dependsOn: [
    adls
  ]
}

module akv 'keyvault.bicep' = {
  name: 'akvDeploy'
  scope: rg
  params: {
    env: env
    location: location
    project: project
    tenantId: tenantId
    tagValues: tagValues
    p: p
    workspaceName: synapse.outputs.workspaceName
    sqlpoolName: synapse.outputs.sqlpoolName
    rgname: rg.name
    randomnum: randomnum
    adfManagedIdentityId: adf.outputs.adfManagedIdentityId
    synapseManagedIdentityId: synapse.outputs.synapseManagedIdentityId
  }
}

