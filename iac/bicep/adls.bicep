param location string 
param env string 
param project string
param tagValues object
param randomnum string

resource adls 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: '${project}${env}${randomnum}'
  location: location
  tags: tagValues
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  // extendedLocation: {
  //   name: 'string'
  //   type: 'EdgeZone'
  // }
  identity: {
    type: 'SystemAssigned'
    // userAssignedIdentities: {}
  }
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    allowCrossTenantReplication: false
    allowSharedKeyAccess: true
    // azureFilesIdentityBasedAuthentication: {
    //   activeDirectoryProperties: {
    //     azureStorageSid: 'string'
    //     domainGuid: 'string'
    //     domainName: 'string'
    //     domainSid: 'string'
    //     forestName: 'string'
    //     netBiosDomainName: 'string'
    //   }
    //   defaultSharePermission: 'string'
    //   directoryServiceOptions: 'string'
    // }
    // customDomain: {
    //   name: 'string'
    //   useSubDomainName: bool
    // }
    defaultToOAuthAuthentication: false
    // encryption: {
    //   identity: {
    //     userAssignedIdentity: 'string'
    //   }
    //   keySource: 'string'
    //   keyvaultproperties: {
    //     keyname: 'string'
    //     keyvaulturi: 'string'
    //     keyversion: 'string'
    //   }
    //   requireInfrastructureEncryption: bool
    //   services: {
    //     blob: {
    //       enabled: bool
    //       keyType: 'string'
    //     }
    //     file: {
    //       enabled: bool
    //       keyType: 'string'
    //     }
    //     queue: {
    //       enabled: bool
    //       keyType: 'string'
    //     }
    //     table: {
    //       enabled: bool
    //       keyType: 'string'
    //     }
    //   }
    // }
    // immutableStorageWithVersioning: {
    //   enabled: bool
    //   immutabilityPolicy: {
    //     allowProtectedAppendWrites: bool
    //     immutabilityPeriodSinceCreationInDays: int
    //     state: 'string'
    //   }
    // }
    isHnsEnabled: true
    isNfsV3Enabled: false
    keyPolicy: {
      keyExpirationPeriodInDays: 90
    }
    largeFileSharesState: 'Disabled'
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    publicNetworkAccess: 'Disabled'
    routingPreference: {
      publishInternetEndpoints: false
      publishMicrosoftEndpoints: true
      routingChoice: 'MicrosoftRouting'
    }
    supportsHttpsTrafficOnly: true
  }
}

resource adlsContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: '${adls.name}/default/synapsefs'
  properties: {
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
}


output accountUrl string = 'https://${adls.name}.dfs.${environment().suffixes.storage}'

output accountResourceId string = adls.id
