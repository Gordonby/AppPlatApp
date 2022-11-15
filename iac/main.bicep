param nameseed string = 'appplat-t3'
param location string = resourceGroup().location

var uniqueSuffix = uniqueString(resourceGroup().id, deployment().name)

module webApps 'webapps.bicep' = {
  name: '${deployment().name}-webapps'
  params: {
    nameseed: nameseed
    location: location
    uniqueSuffix: uniqueSuffix
  }
}

// resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' = {
//   name: 'db-${nameseed}-${uniqueSuffix}'
//   location: location
//   kind: 'GlobalDocumentDB'
//   properties: {
//     consistencyPolicy: {
//       defaultConsistencyLevel: 'Eventual'
//       maxStalenessPrefix: 1
//       maxIntervalInSeconds: 5
//     }
//     locations: [
//       {
//         locationName: location
//         failoverPriority: 0
//       }
//     ]
//     databaseAccountOfferType: 'Standard'
//     enableAutomaticFailover: true
//     capabilities: [
//       {
//         name: 'EnableTable'
//       }
//     ]
//   }
// }
