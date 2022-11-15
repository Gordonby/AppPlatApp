param nameseed string = 'appplat'
param location string = resourceGroup().location

resource webApplication 'Microsoft.Web/sites@2022-03-01' = {
  name: 'web-${nameseed}'
  location: location
  tags: {
    'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/appServicePlan': 'Resource'
  }
  properties: {
    serverFarmId: appServicePlan.id
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'name'
  location: location
  sku: {
    name: 'F1'
    capacity: 1
  }
}



resource codeDeploy 'Microsoft.Web/sites/sourcecontrols@2022-03-01' = {
  parent: webApplication
  name: 'web'
  properties: {
    repoUrl: 'https://github.com/marconsilva/HumungousHealthcare/web'
    branch: 'main'
    isManualIntegration: true
  }
}
