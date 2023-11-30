param acrName string 
param acrLocation string = 'West US'
param appServicePlanName string
param appServicePlanLocation string = 'West US'

module registry './modules/container-registry/registry/main.bicep' = {
  name: acrName
  params: {
    name: acrName
    location: acrLocation
    acrAdminUserEnabled: true
  }
}

module serverfarm './modules/web/serverfarm/main.bicep' = {
  name: '${appServicePlanName}-deploy'
  params: {
    name: appServicePlanName
    location: appServicePlanLocation
    sku: {
      capacity: 1
      family: 'B'
      name: 'B1'
      size: 'B1'
      tier: 'Basic'
      reserved: true
    }
  }
}
