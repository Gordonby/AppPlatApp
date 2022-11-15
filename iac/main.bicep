param nameseed string = 'appplat-t3'
param location string = resourceGroup().location

var uniqueSuffix = uniqueString(resourceGroup().id, deployment().name)

@description('An array of the web component directory names to deploy to App Services')
var webComponentDirectoriesToDeploy = ['web', 'api']

resource webApplication 'Microsoft.Web/sites@2022-03-01' = [for webComponent in webComponentDirectoriesToDeploy : {
  name: '${webComponent}-${nameseed}-${uniqueSuffix}'
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
          value: webComponent
        }
      ]
    }
    serverFarmId: appServicePlan.id
  }
}]

resource codeDeploy 'Microsoft.Web/sites/sourcecontrols@2022-03-01' = [for (webComponent, i) in webComponentDirectoriesToDeploy :  {
  parent: webApplication[i]
  name: 'web'
  properties: {
    repoUrl: 'https://github.com/Gordonby/AppPlatApp.git'
    branch: 'main'
    isManualIntegration: true
  }
}]

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


