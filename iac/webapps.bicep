param nameseed string
param location string = resourceGroup().location
param uniqueSuffix string 

resource webApplication 'Microsoft.Web/sites@2022-03-01' = {
  name: 'web-${nameseed}-${uniqueSuffix}'
  location: location
  tags: {
    'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/appServicePlan': 'Resource'
    'created-with': 'bicep'
    'created-by': 'gordon'
  }
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'SCM_REPOSITORY_PATH'
          value: 'web'
        }
        {
          name: 'APIENDPOINT'
          value: 'https://${apiApplication.properties.defaultHostName}/'
        }
        {
          name: 'REACT_APP_API_URL'
          value: 'https://${apiApplication.properties.defaultHostName}/'
        }
      ]
    }
    serverFarmId: appServicePlan.id
  }
}

resource apiApplication 'Microsoft.Web/sites@2022-03-01' =  {
  name: 'api-${nameseed}-${uniqueSuffix}'
  location: location
  tags: {
    'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/appServicePlan': 'Resource'
    'created-with': 'bicep'
    'created-by': 'gordon'
  }
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'SCM_REPOSITORY_PATH'
          value: 'api'
        }
      ]
      cors: {
        allowedOrigins: [
          '*'
        ]
        supportCredentials: false
      }
    }
    serverFarmId: appServicePlan.id
  }
}

resource WebCodeDeploy 'Microsoft.Web/sites/sourcecontrols@2022-03-01' = {
  parent: webApplication
  name: 'web'
  properties: {
    repoUrl: 'https://github.com/Gordonby/AppPlatApp.git'
    branch: 'main'
    isManualIntegration: true
  }
}

resource codeDeploy 'Microsoft.Web/sites/sourcecontrols@2022-03-01' = {
  parent: apiApplication
  name: 'web'
  properties: {
    repoUrl: 'https://github.com/Gordonby/AppPlatApp.git'
    branch: 'main'
    isManualIntegration: true
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'asp-${nameseed}-${uniqueSuffix}'
  location: location
  tags: {
    'created-with': 'bicep'
    'created-by': 'gordon'
  }
  sku: {
    name: 'F1'
    capacity: 1
  }
}
