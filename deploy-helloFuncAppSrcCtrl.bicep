/*
   Begin common prolog commands
   $env:name='helloFuncAppSrcCtrl'
   $env:rg="rg_$env:name"
   $env:loc='eastus2'
   End common prolog commands

   emacs F10
   Begin commands to deploy this file using Azure CLI with PowerShell
   write-output "begin deploy $env:rg"
   write-output "az deployment group create --name $env:name --resource-group $env:rg --mode Incremental --template-file  deploy-helloFuncAppSrcCtrl.bicep"
   az deployment group create --name $env:name --resource-group $env:rg --mode Incremental --template-file  deploy-helloFuncAppSrcCtrl.bicep | tr '\r' -d
   write-output "end deploy $env:rg"
   End commands to deploy this file using Azure CLI with PowerShell

   emacs ESC 2 F10
   Begin commands to shut down this deployment using Azure CLI with PowerShell
   write-output "begin shutdown $env:rg"
   write-output "az deployment group create --mode complete --template-file ./clear-resources.json --resource-group $env:rg"
   az deployment group create --mode complete --template-file ./clear-resources.json --resource-group $env:rg | tr '\r' -d
   write-output "end shutdown $env:rg"
   End commands to shut down this deployment using Azure CLI with PowerShell

   emacs ESC 3 F10
   Begin commands for one time initializations using Azure CLI with PowerShell
   az group create -l $env:loc -n $env:rg
   $env:id=(az group show --name $env:rg --query 'id' --output tsv)
   write-output "id=$env:id"
   $env:sp="spad_$env:name"
   #az ad sp create-for-rbac --name $env:sp --json-auth --role contributor --scopes $env:id
   write-output "go to github settings->secrets and create a secret called AZURE_CREDENTIALS with the above output"
   write-output "{`n`"`$schema`": `"https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#`",`n `"contentVersion`": `"1.0.0.0`",`n `"resources`": [] `n}" | Out-File -FilePath clear-resources.json
   End commands for one time initializations using Azure CLI with PowerShell

   Begin common epilog commands
   Get-AzResource -ResourceGroupName $env:rg | ft
   End common epilog commands

 */
param serverfarms_EastUS2Plan_name string = 'EastUS2Plan'
param sites_HelloFunctionAppSourceControl20240512105218_name string = 'HelloFunctionAppSourceControl20240512105218'

resource serverfarms_EastUS2Plan_name_resource 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: serverfarms_EastUS2Plan_name
  location: 'East US 2'
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
    size: 'Y1'
    family: 'Y'
    capacity: 0
  }
  kind: 'functionapp'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

resource sites_HelloFunctionAppSourceControl20240512105218_name_resource 'Microsoft.Web/sites@2023-01-01' = {
  name: sites_HelloFunctionAppSourceControl20240512105218_name
  location: 'East US 2'
  kind: 'functionapp'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: 'hellofunctionappsourcecontrol20240512105218.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: 'hellofunctionappsourcecontrol20240512105218.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: serverfarms_EastUS2Plan_name_resource.id
    reserved: false
    isXenon: false
    hyperV: false
    vnetRouteAllEnabled: false
    vnetImagePullEnabled: false
    vnetContentShareEnabled: false
    siteConfig: {
      numberOfWorkers: 1
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: false
      functionAppScaleLimit: 200
      minimumElasticInstanceCount: 0
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    customDomainVerificationId: '601761B423669B426FBA3224672CADEADB619B49AC0996F9DE5EBCE97DAABD8B'
    containerSize: 1536
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    redundancyMode: 'None'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}

resource sites_HelloFunctionAppSourceControl20240512105218_name_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2023-01-01' = {
  parent: sites_HelloFunctionAppSourceControl20240512105218_name_resource
  name: 'ftp'
  location: 'East US 2'
  properties: {
    allow: false
  }
}

resource sites_HelloFunctionAppSourceControl20240512105218_name_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2023-01-01' = {
  parent: sites_HelloFunctionAppSourceControl20240512105218_name_resource
  name: 'scm'
  location: 'East US 2'
  properties: {
    allow: false
  }
}

resource sites_HelloFunctionAppSourceControl20240512105218_name_web 'Microsoft.Web/sites/config@2023-01-01' = {
  parent: sites_HelloFunctionAppSourceControl20240512105218_name_resource
  name: 'web'
  location: 'East US 2'
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
    ]
    netFrameworkVersion: 'v8.0'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    httpLoggingEnabled: false
    acrUseManagedIdentityCreds: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    publishingUsername: '$HelloFunctionAppSourceControl20240512105218'
    scmType: 'None'
    use32BitWorkerProcess: false
    webSocketsEnabled: false
    alwaysOn: false
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: false
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    vnetRouteAllEnabled: false
    vnetPrivatePortsCount: 0
    localMySqlEnabled: false
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: false
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'FtpsOnly'
    preWarmedInstanceCount: 0
    functionAppScaleLimit: 200
    functionsRuntimeScaleMonitoringEnabled: false
    minimumElasticInstanceCount: 0
    azureStorageAccounts: {}
  }
}

resource sites_HelloFunctionAppSourceControl20240512105218_name_b0d0b989910444fdb40285625131fa5e 'Microsoft.Web/sites/deployments@2023-01-01' = {
  parent: sites_HelloFunctionAppSourceControl20240512105218_name_resource
  name: 'b0d0b989910444fdb40285625131fa5e'
  location: 'East US 2'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'ZipDeploy'
    message: 'Created via a push deployment'
    start_time: '2024-05-12T17:56:59.2096895Z'
    end_time: '2024-05-12T17:57:00.5847194Z'
    active: true
  }
}

resource sites_HelloFunctionAppSourceControl20240512105218_name_HelloFunctionApp 'Microsoft.Web/sites/functions@2023-01-01' = {
  parent: sites_HelloFunctionAppSourceControl20240512105218_name_resource
  name: 'HelloFunctionApp'
  location: 'East US 2'
  properties: {
    script_href: 'https://hellofunctionappsourcecontrol20240512105218.azurewebsites.net/admin/vfs/site/wwwroot/HelloFunctionAppSourceControl.dll'
    test_data_href: 'https://hellofunctionappsourcecontrol20240512105218.azurewebsites.net/admin/vfs/data/Functions/sampledata/HelloFunctionApp.dat'
    href: 'https://hellofunctionappsourcecontrol20240512105218.azurewebsites.net/admin/functions/HelloFunctionApp'
    config: {}
    invoke_url_template: 'https://hellofunctionappsourcecontrol20240512105218.azurewebsites.net/api/hellofunctionapp'
    language: 'dotnet-isolated'
    isDisabled: false
  }
}

resource sites_HelloFunctionAppSourceControl20240512105218_name_sites_HelloFunctionAppSourceControl20240512105218_name_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2023-01-01' = {
  parent: sites_HelloFunctionAppSourceControl20240512105218_name_resource
  name: '${sites_HelloFunctionAppSourceControl20240512105218_name}.azurewebsites.net'
  location: 'East US 2'
  properties: {
    siteName: 'HelloFunctionAppSourceControl20240512105218'
    hostNameType: 'Verified'
  }
}



