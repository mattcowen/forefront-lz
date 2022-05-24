param keyVaultName string
@secure()
param pfx string
// param username string
// @secure()
// param password string
param location string = resourceGroup().location
param tenantid string = subscription().tenantId
param encryptionKeyName string

resource script 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'CmkAzCliScript'
  location: location
  kind: 'AzureCLI'
  properties: {
    forceUpdateTag: '1'
    containerSettings: {
      containerGroupName: 'cmkAci'
    }
    azCliVersion: '2.29.2'
    environmentVariables: [
      {
        name: 'PFX'
        secureValue: pfx
      }
      {
        name: 'KEY_VAULT_NAME'
        value: keyVaultName
      }
      // {
      //   name: 'USERNAME'
      //   value: username
      // }
      // {
      //   name: 'PASSWORD'
      //   secureValue: password
      // }
      {
        name: 'TENANTID'
        value: tenantid
      }
      {
        name: 'ENCRYPTION_KEY_NAME'
        value: encryptionKeyName
      }
    ]
    scriptContent: '''
      #az login --service-principal -u $USERNAME -p $PASSWORD -t $TENANTID
      KEY=$(echo $PFX | base64 -d | openssl pkcs12 -nocerts -nodes -passin 'pass:' | tail -n +7)
      OUTPUT=$(az keyvault key import --vault-name $KEY_VAULT_NAME -n "${ENCRYPTION_KEY_NAME}" --pem-string="${KEY}" --query key.kid -o tsv)
      echo "{ keyId: '${OUTPUT}' }" > $AZ_SCRIPTS_OUTPUT_PATH
    '''
    timeout: 'PT30M'
    cleanupPreference: 'Always'
    retentionInterval: 'PT1H'
  }
}

output keyId string = script.properties.outputs.keyId
