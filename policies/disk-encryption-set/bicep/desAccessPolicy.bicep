resource kv 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: 'identity-sub-kv'
}

resource des 'Microsoft.Compute/diskEncryptionSets@2021-08-01' existing = {
  name: 'cmk-platform-des'
  scope: resourceGroup('cmk-encryption-rg')
}

resource keyVaultReaderRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid('Key Vault Reader', des.name, subscription().subscriptionId, kv.name)
  scope: kv
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
    principalId: des.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

resource ap 'Microsoft.KeyVault/vaults/accessPolicies@2021-11-01-preview' = {
  name: 'add'
  parent: kv
  properties: {
    accessPolicies: [
      {
        tenantId: des.identity.tenantId
        objectId: des.identity.principalId
        permissions: {
          keys: [
            'get'
            'wrapKey'
            'unwrapKey'
          ]
        }
      }
    ]
  }
}
