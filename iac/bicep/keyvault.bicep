param location string
param env string
param project string
param p string 
param tenantId string
param tagValues object
param workspaceName string
param sqlpoolName string
param rgname string
param randomnum string
param adfManagedIdentityId string
param synapseManagedIdentityId string

resource kv 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: 'kv-${project}-${env}${randomnum}'
  location: location
  tags: tagValues
  properties: {
    accessPolicies: [
      {
        objectId: adfManagedIdentityId
        permissions: {
          secrets: [ 
            'get'
            'list'
           ]
        }
        tenantId: tenantId
      }
      {
        objectId: synapseManagedIdentityId
        permissions: {
          secrets: [ 
            'get'
            'list'
           ]
        }
        tenantId: tenantId
      }
    ]
    tenantId: tenantId
    createMode: 'default'
    enablePurgeProtection: true
    enableRbacAuthorization: false
    enableSoftDelete: false
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    // provisioningState: 'string'
    publicNetworkAccess: 'disabled'
    sku: {
      family: 'A'
      name: 'standard'
    }
    // softDeleteRetentionInDays: int
    // tenantId: 'string'
    // vaultUri: 'string'
  }
}

resource sqlpoolpw 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  name: 'sqlpoolconnstr'
  tags: tagValues
  parent: kv
  properties: {
    attributes: {
      // enabled: bool
      // exp: int
      // nbf: int
    }
    contentType: 'string'
    value: 'Server=tcp:${workspaceName}${environment().suffixes.sqlServerHostname},1433;Initial Catalog=${sqlpoolName};Persist Security Info=False;User ID=synapseadminusr;Password=${p};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'
  }
}

resource rgnameSecret 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  name: 'rgname'
  tags: tagValues
  parent: kv
  properties: {
    attributes: {
      // enabled: bool
      // exp: int
      // nbf: int
    }
    contentType: 'string'
    value: rgname
  }
}

resource workspaceNameSecret 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  name: 'workspaceName'
  tags: tagValues
  parent: kv
  properties: {
    attributes: {
      // enabled: bool
      // exp: int
      // nbf: int
    }
    contentType: 'string'
    value: workspaceName
  }
}

resource sqlpoolNameSecret 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  name: 'sqlpoolName'
  tags: tagValues
  parent: kv
  properties: {
    attributes: {
      // enabled: bool
      // exp: int
      // nbf: int
    }
    contentType: 'string'
    value: sqlpoolName
  }
}
