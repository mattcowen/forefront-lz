param location string
param destinationKeyVaultResourceGroupName string
param destinationKeyVaultName string
@secure()
param pfx string
// param applicationId string
// @secure()
// param password string

targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'cmk-encryption-rg'
  location: location
}

module cmkencryption 'cmkEncryptionRg.bicep' = {
  name: 'CmkEncryptionModule'
  scope: rg
  params: {
    pfx: pfx
    // applicationId: applicationId
    // password: password
    location: location
    destinationKeyVaultResourceGroupName: destinationKeyVaultResourceGroupName
    destinationKeyVaultName: destinationKeyVaultName
  }
}

module cmkkv 'desAccessPolicy.bicep' = {
  name: 'DesAccessPolicyModule'
  scope: resourceGroup(destinationKeyVaultResourceGroupName)
  dependsOn: [
    cmkencryption
  ]
}
