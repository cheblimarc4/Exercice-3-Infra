param acrName string 
param acrLocation string = 'West US'
param appServicePlanName string
param appServicePlanLocation string = 'West US'
param webAppName string ='marc-webapp'
param webAppLocation string = 'West US'
param containerRegistryImageName string = 'flask-demo'
param containerRegistryImageVersion string = 'latest'
param dockerRegistryServerUrl string ='https://${acrName}.azurecr.io'
param dockerRegistryServerUsername string = 'marcchebli'
@secure()
param dockerRegistryServerPassword string

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
    }
    reserved: true
  }
}

module webApp './modules/web/site/main.bicep' = {
  name: '${webAppName}-deploy'
  params: {
    name: webAppName
    location: webAppLocation
    kind: 'app'
    serverFarmResourceId: resourceId('Microsoft.Web/serverfarms', appServicePlanName)
    siteConfig: {
      linuxFxVersion: 'DOCKER|${acrName}.azurecr.io/${containerRegistryImageName}:${containerRegistryImageVersion}'
      appCommandLine: ''
    }
    appSettingsKeyValuePairs: {
      WEBSITES_ENABLE_APP_SERVICE_STORAGE: false
      DOCKER_REGISTRY_SERVER_URL: dockerRegistryServerUrl
      DOCKER_REGISTRY_SERVER_USERNAME: dockerRegistryServerUsername
      DOCKER_REGISTRY_SERVER_PASSWORD: dockerRegistryServerPassword
    }
  }
}
