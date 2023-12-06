param acrName string 
param location string 
param appServicePlanName string
param webAppName string ='marc-webapp'
param containerRegistryImageName string = 'flask-demo'
param containerRegistryImageVersion string = 'latest'
@secure()
param DOCKER_REGISTRY_SERVER_PASSWORD string = 'marc1234'
param DOCKER_REGISTRY_SERVER_USERNAME string 
param DOCKER_REGISTRY_SERVER_URL string  
module registry './Ressources/ResourceModules-main 3/modules/container-registry/registry/main.bicep' = {
  name: acrName
  params: {
    name: acrName
    location: location
    acrAdminUserEnabled: true
  }
}

module serverfarm './Ressources/ResourceModules-main 3/modules/web/serverfarm/main.bicep' = {
  name: '${appServicePlanName}-deploy'
  params: {
    name: appServicePlanName
    location: location
    sku: {
      capacity: 1
      family: 'B'
      name: 'B1'
      size: 'B1'
      tier: 'Basic'
    }
    reserved: true
  }
}

module site './Ressources/ResourceModules-main 3/modules/web/site/main.bicep' = {
  name: 'siteModule'
  params: {
    kind: 'app'
    name: webAppName
    location: location
    serverFarmResourceId: serverfarm.outputs.resourceId
    siteConfig: {
      linuxFxVersion: 'DOCKER|${acrName}.azurecr.io/${containerRegistryImageName }:${containerRegistryImageVersion}'
      appCommandLine: ''
    }
    appSettingsKeyValuePairs : {
      WEBSITES_ENABLE_APP_SERVICE_STORAGE: false
      DOCKER_REGISTRY_SERVER_URL: DOCKER_REGISTRY_SERVER_URL
      DOCKER_REGISTRY_SERVER_USERNAME: DOCKER_REGISTRY_SERVER_USERNAME
      DOCKER_REGISTRY_SERVER_PASSWORD: DOCKER_REGISTRY_SERVER_PASSWORD
    }
  }
}
