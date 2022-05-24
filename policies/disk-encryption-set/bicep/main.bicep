// param applicationId string
// @secure()
// param password string
param location string

param sourceSubscriptionId string
param sourceResourceGroupName string
param sourceKeyVaultName string
param sourceCmkCertificateName string

param destinationSubscriptionId string
param destinationKeyVaultResourceGroupName string
param destinationKeyVaultName string

targetScope = 'subscription'

resource bootstrapkv 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: sourceKeyVaultName
  scope: resourceGroup(sourceSubscriptionId, sourceResourceGroupName)
}

module identitysub 'identitysub.bicep' = {
  name: 'IdentitySubscriptionModule'
  scope: subscription(destinationSubscriptionId)
  params: {
    // applicationId: applicationId
    // password: password
    pfx: bootstrapkv.getSecret(sourceCmkCertificateName)
    destinationKeyVaultResourceGroupName: destinationKeyVaultResourceGroupName
    destinationKeyVaultName: destinationKeyVaultName
    location: location
  }
}
