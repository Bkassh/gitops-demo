############################ Container Insights enablement ############################################
$resourceGroupName = "rg-compredict"
$deploymentName = "containerinsights"
$templateFile = "C:\path\to\your\ContainerInsightsExistingClusterOnboarding.json"
$templateParameterFile = "C:\path\to\your\ContainerInsightsExistingClusterParam.json"

$params = @{"aksResourceId"= "/path/to/your/aksResourceId"
            "aksResourceLocation"= "eastus2"
            "workspaceResourceId"= "/path/to/your/workspaceResourceId"
            "workspaceRegion"= "eastus2"
            "enableContainerLogV2"= $true
            "enableSyslog"= $false
            "syslogLevels"= @( "Debug", "Info", "Notice", "Warning", "Error", "Critical", "Alert", "Emergency" )
           "syslogFacilities"=@(
    "auth",
    "authpriv",
    "cron",
    "daemon",
    "mark",
    "kern",
    "local0",
    "local1",
    "local2",
    "local3",
    "local4",
    "local5",
    "local6",
    "local7",
    "lpr",
    "mail",
    "news",
    "syslog",
    "user",
    "uucp"
  )
"resourceTagValues"= @{
    "evn"= "dev"
    "app"= "sonet"
    "group"= "chees"
  }
"dataCollectionInterval"= "1m"
"namespaceFilteringModeForDataCollection"= "Off"
"namespacesForDataCollection"=@(
    "kube-system",
    "gatekeeper-system",
    "azure-arc"
)
"streams"= @(
    "Microsoft-ContainerLog",
    "Microsoft-ContainerLogV2",
    "Microsoft-KubeEvents",
    "Microsoft-KubePodInventory",
    "Microsoft-KubeNodeInventory",
    "Microsoft-KubePVInventory",
    "Microsoft-KubeServices",
    "Microsoft-KubeMonAgentEvents",
    "Microsoft-InsightsMetrics",
    "Microsoft-ContainerInventory",
    "Microsoft-ContainerNodeInventory",
    "Microsoft-Perf"
  )
"useAzureMonitorPrivateLinkScope"= $false
"azureMonitorPrivateLinkScopeResourceId" = "/path/to/your/azureMonitorPrivateLinkScopeResourceId"
}

# Deploy the ARM template
New-AzResourceGroupDeployment -Name $deploymentName `
                          -ResourceGroupName $resourceGroupName `
                          -TemplateFile $templateFile `
                          -TemplateParameterObject $params