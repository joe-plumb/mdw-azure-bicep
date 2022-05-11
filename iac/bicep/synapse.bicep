param location string
param env string
param project string
param accountUrl string
param accountResourceId string
param p string 
param tagValues object
param randomnum string

resource synapsews 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: 'synws${project}${env}${randomnum}'
  location: location
  tags: tagValues
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    connectivityEndpoints: {}
    cspWorkspaceAdminProperties: {
      initialWorkspaceAdminObjectId: '2252f4dd-bc32-43c3-9c84-836f31e2d18d'
    }
    defaultDataLakeStorage: {
      accountUrl: accountUrl
      createManagedPrivateEndpoint: true
      filesystem: 'synapsefs'
      resourceId: accountResourceId
    }
    // encryption: {
    //   cmk: {
    //     kekIdentity: {
    //       userAssignedIdentity: 'string'
    //       useSystemAssignedIdentity: any()
    //     }
    //     key: {
    //       keyVaultUrl: 'string'
    //       name: 'string'
    //     }
    //   }
    // }
    managedResourceGroupName: '${project}${env}synmanvnet${randomnum}'
    managedVirtualNetwork: 'default'
    managedVirtualNetworkSettings: {
      allowedAadTenantIdsForLinking: [ 
        '72f988bf-86f1-41af-91ab-2d7cd011db47' 
      ]
      linkedAccessCheckOnTargetResource: true
      preventDataExfiltration: true
    }
    privateEndpointConnections: [
      {
        properties: {
          privateEndpoint: {}
          privateLinkServiceConnectionState: {
            description: 'cleopoc workspace private endpoint'
            status: 'string'
          }
        }
      }
    ]
    publicNetworkAccess: 'Disabled'
    // purviewConfiguration: {
    //   purviewResourceId: 'string'
    // }
    sqlAdministratorLogin: 'synapseadminusr'
    sqlAdministratorLoginPassword: p
    // virtualNetworkProfile: {
    //   computeSubnetId: 'string'
    // }
    // workspaceRepositoryConfiguration: {
    //   accountName: 'string'
    //   collaborationBranch: 'string'
    //   hostName: 'string'
    //   lastCommitId: 'string'
    //   projectName: 'string'
    //   repositoryName: 'string'
    //   rootFolder: 'string'
    //   tenantId: 'string'
    //   type: 'string'
    // }
  }
}

resource sqlpool 'Microsoft.Synapse/workspaces/sqlPools@2021-06-01' = {
  name: project
  location: location
  tags: tagValues
  sku: {
    name: 'DW100c'
  }
  parent: synapsews
  properties: {
    createMode: 'Default'
    storageAccountType: 'LRS'
  }
}

output workspaceName string = synapsews.name

output sqlpoolName string = sqlpool.name

output synapseManagedIdentityId string = synapsews.identity.principalId
