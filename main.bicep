param acrName string 
param acrLocation string = 'West US'
param appServicePlanName string
param appServicePlanLocation string
param webAppName string
param webAppLocation string
param containerRegistryImageName string
param containerRegistryImageVersion string
param dockerRegistryServerUrl string
param dockerRegistryServerUsername string
param dockerRegistryServerPassword string

module registry './modules/container-registry/registry/main.bicep' = {
  name: acrName
  params: {
    name: acrName
    location: acrLocation
    acrAdminUserEnabled: true
  }
}

