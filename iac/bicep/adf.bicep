param location string 
param env string
param tagValues object
// param tenantId string
param randomnum string

resource adf 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: 'df-cleoing-${env}${randomnum}'
  location: location
  tags: tagValues
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    globalParameters: {
      GlobalParameterSpecification:{
        type: 'String'
        value: env
      }
      
    }
    publicNetworkAccess: 'Enabled'
    // repoConfiguration: {
    //   type: 'FactoryVSTSConfiguration'
    //   projectName: 'moderndatawarehouse'
    //   tenantId: tenantId
    //   accountName: 'string'
    //   collaborationBranch: 'main'
    //   repositoryName: 'cleoinfra'
    //   rootFolder: 'adf'
    //   // For remaining properties, see FactoryRepoConfiguration objects
    // }
  }
}

output adfManagedIdentityId string = adf.identity.principalId

