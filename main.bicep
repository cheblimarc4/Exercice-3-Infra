param acrName string 
param acrLocation string = 'West US'
param appServicePlanName string
param appServicePlanLocation string = 'West US'
param webAppName string ='marc-webapp'
param webAppLocation string = 'West US'
param containerRegistryImageName string = 'flask-demo'
param containerRegistryImageVersion string = 'latest'
param DOCKER_REGISTRY_SERVER_USERNAME string 
@secure()
param DOCKER_REGISTRY_SERVER_PASSWORD string

module registry './Ressources/ResourceModules-main 3/modules/container-registry/registry/main.bicep' = {
  name: acrName
  params: {
    name: acrName
    location: acrLocation
    acrAdminUserEnabled: true
  }
}

module serverfarm './Ressources/ResourceModules-main 3/modules/web/serverfarm/main.bicep' = {
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
    }
    reserved: true
  }
}

module site './Ressources/ResourceModules-main 3/modules/web/site/main.bicep' = {
  name: 'siteModule'
  params: {
    kind: 'app'
    name: webAppName
    location: webAppLocation
    serverFarmResourceId: resourceId('Microsoft.Web/serverfarms', appServicePlanName)
    siteConfig: {
      linuxFxVersion: 'DOCKER|${acrName}.azurecr.io/${containerRegistryImageName }:${containerRegistryImageVersion}'
      appCommandLine: ''
    }
    appSettingsKeyValuePairs : {
      WEBSITES_ENABLE_APP_SERVICE_STORAGE: false
      DOCKER_REGISTRY_SERVER_URL: 'https://${acrName}.azurecr.io'
      DOCKER_REGISTRY_SERVER_USERNAME: DOCKER_REGISTRY_SERVER_USERNAME
      DOCKER_REGISTRY_SERVER_PASSWORD: DOCKER_REGISTRY_SERVER_PASSWORD
    }
  }
}
