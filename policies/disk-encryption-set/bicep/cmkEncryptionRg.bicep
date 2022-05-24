param location string = resourceGroup().location
param destinationKeyVaultResourceGroupName string
param destinationKeyVaultName string
@secure()
param pfx string
// param applicationId string
// @secure()
// param password string

resource kv 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: destinationKeyVaultName
  scope: resourceGroup(destinationKeyVaultResourceGroupName)
}

module cmkImport './cmkImport.bicep' = {
  name: 'CmkImport'
  params: {
    location: location
    keyVaultName: kv.name
    pfx: pfx
    // username: applicationId
    // password: password
    encryptionKeyName: 'cmk-encryption-key'
  }
}

resource des 'Microsoft.Compute/diskEncryptionSets@2021-08-01' = {
  name: 'cmk-platform-des'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    activeKey: {
      sourceVault: {
        id: kv.id
      }
      keyUrl: cmkImport.outputs.keyId
    }
    encryptionType: 'EncryptionAtRestWithCustomerKey'
    rotationToLatestKeyVersionEnabled: true
  }
}
