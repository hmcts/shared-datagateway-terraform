Param(
	

	# AAD Application Id to install the data gateway under: https://docs.microsoft.com/en-us/powershell/module/datagateway.profile/connect-datagatewayserviceaccount?view=datagateway-ps
	[Parameter(Mandatory = $true)][string]$Connect_Username,

	# AAD Application secret: https://docs.microsoft.com/en-us/powershell/module/datagateway.profile/connect-datagatewayserviceaccount?view=datagateway-ps
	[Parameter(Mandatory = $true)][string]$Connect_Password,

	# AAD Tenant Id (or name): https://docs.microsoft.com/en-us/powershell/module/datagateway.profile/connect-datagatewayserviceaccount?view=datagateway-ps
	[Parameter(Mandatory = $true)][string]$TenantId,

	# Documented on the Install-DataGateway: https://docs.microsoft.com/en-us/powershell/module/datagateway/install-datagateway?view=datagateway-ps
	[Parameter()][string]$InstallerLocation="GatewayInstall.exe",

	# Documented on the Add-DataGatewayCluster: https://docs.microsoft.com/en-us/powershell/module/datagateway/add-datagatewaycluster?view=datagateway-ps
	[Parameter(Mandatory = $true)][string]$RegionKey,

	# Documented on the Add-DataGatewayCluster: https://docs.microsoft.com/en-us/powershell/module/datagateway/add-datagatewaycluster?view=datagateway-ps
	[Parameter(Mandatory = $true)][string]$RecoveryKey,

	# Documented on the Add-DataGatewayCluster: https://docs.microsoft.com/en-us/powershell/module/datagateway/add-datagatewaycluster?view=datagateway-ps
	[Parameter(Mandatory = $true)][string]$GatewayName,

	# Documented on the Add-DataGatewayClusterUser: https://docs.microsoft.com/en-us/powershell/module/datagateway/add-datagatewayclusteruser?view=datagateway-ps
	[Parameter()][string]$GatewayAdminUserIds
)

# Import log utils
. .\logUtil.ps1

$logger = [TraceLog]::new("$env:SystemDrive\WindowsAzure\Logs\Plugins\", "pbisetup.log")

# Install the Power BI Gateway under a PowerShell v7 shell
$progressMsg = "Installing PBI Gateway under PowerShell v7 shell"
$logger.Log($progressMsg)
Write-Output($progressMsg)

# Pass thru params into main pbi gateway installer script
#$params = "-File .\pbiGatewayInstall.ps1 -AppId ""$AppId"" -Secret ""$Secret"" -TenantId ""$TenantId"" -InstallerLocation ""$InstallerLocation"" -RecoveryKey ""$RecoveryKey"" -GatewayName ""$GatewayName"" -Region ""$RegionKey"" -GatewayAdminUserIds ""$GatewayAdminUserIds"""
$params = "-File .\pbiGatewayInstall.ps1 -Connect_Username $Connect_Username -Connect_Password $Connect_Password -TenantId $TenantId -InstallerLocation $InstallerLocation -RecoveryKey $RecoveryKey -GatewayName $GatewayName -Region $RegionKey -GatewayAdminUserIds $GatewayAdminUserIds"
$result = Invoke-Process "$env:ProgramFiles\PowerShell\7\pwsh.exe" $params $logger


# Write output
$progressMsg = "Result=$($result['Output']) \n\rExitCode=$($result['ExitCode'])"
Write-Output($progressMsg)