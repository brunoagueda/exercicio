@description('The Azure region into which the resources should be deployed.')
param location string = resourceGroup().location

@description('The type of environment. This must be nonprod or prod.')
@allowed([
  'nonprod'
  'prod'
])
param environmentType string

// Define the SKUs for each component based on the environment type.
var environmentConfigurationMap = {
  nonprod: {
    appServicePlan: {
      sku: {
        name: 'F1'
        capacity: 1
      }
    }
    appServiceAppName:{
      name:'nonprod-app-churables'
    }
    appServicePlanName:{
      name:'nonprod-app-plan'
    }
  }
  prod: {
    appServicePlan: {
      sku: {
        name: 'S1'
        capacity: 2
      }
    }
    appServiceAppName:{
      name:'prod-app-churables'
    }
    appServicePlanName:{
      name:'prod-app-plan'
    }
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: environmentConfigurationMap[environmentType].appServicePlanName.name
  location: location
  sku: environmentConfigurationMap[environmentType].appServicePlan.sku
}

resource webApplication 'Microsoft.Web/sites@2021-01-15' = {
  name: environmentConfigurationMap[environmentType].appServiceAppName.name
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}

//output hostname string = environmentConfigurationMap[environmentType].appServiceAppName.name

