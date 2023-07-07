#remove the file if exist already
Remove-Item -Path C:\Packages\Plugins\full_install_script.ps1 

# Create new script file
New-Item C:\Packages\Plugins\full_install_script.ps1 -ItemType File

# Add content to the script file
Add-Content C:\Packages\Plugins\full_install_script.ps1 @'

# Create  new log file
Add-Content -Path C:\Packages\Plugins\gateway_log.txt -Value "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") Start running script"
$App_Id = "${App_Id}"
$App_Secret = "${App_Secret}"
$TenantId = "${TenantId}"
$InstallerLocation="GatewayInstall.exe"
$InstanceName =  "${InstanceName}"
$RecoveryKey = "${RecoveryKey}"
$GatewayName = "${GatewayName}"
$GatewayAdminUserIds =  "${GatewayAdminUserIds}"
$RegionKey = "${RegionKey}"

Add-Content -Path C:\Packages\Plugins\gateway_log.txt -Value "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") powershell version is $PSVersionTable.PSVersion.Major"

if (($PSVersionTable).PSVersion.Major -lt 7) {
    $progressMsg = "Error: This script requires PowerShell v7 or above"
    Add-Content -Path C:\Packages\Plugins\gateway_log.txt -Value "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") $progressMsg"
    Write-Error($progressMsg)
    exit 1
}

# Install the DataGateway module if not already available
if (!(Get-InstalledModule "DataGateway" -ErrorAction SilentlyContinue)) {
    $progressMsg = "Installing DataGateway PS Module"
    Add-Content -Path C:\Packages\Plugins\gateway_log.txt -Value "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") $progressMsg"
    Write-Host($progressMsg)
    Install-Module -Name DataGateway -Force -Scope AllUsers
}

$secureAppSecret = ConvertTo-SecureString $App_Secret -AsPlainText
$secureRecoveryKey = ConvertTo-SecureString $RecoveryKey -AsPlainText


# Connect to the Data Gateway service
$progressMsg = "Connect to the Data Gateway Service"
Add-Content -Path C:\Packages\Plugins\gateway_log.txt -Value "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") $progressMsg"
Write-Host($progressMsg)
$connected = (Connect-DataGatewayServiceAccount  -ApplicationId $App_Id -ClientSecret $secureAppSecret -Tenant $TenantId)
if ($null -eq $connected) {
    # Surface last error detail
    $lastError = Resolve-DataGatewayError -Last
    # $logger.Log($lastError.Message)
    Write-Host($lastError.Message)

    $progressMsg = "Error: Connecting to Data Gateway Service"
    Add-Content -Path C:\Packages\Plugins\gateway_log.txt -Value "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") $progressMsg"
    Write-Error($progressMsg)
    exit 1    
}

# Check if gateway already installed
# if (!(IsInstalled 'GatewayComponents' $logger)) {
    # Install the gateway on machine
    $progressMsg = "Installing Data Gateway"
    Add-Content -Path C:\Packages\Plugins\gateway_log.txt -Value "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") $progressMsg"
    Write-Host($progressMsg)

    if (!(Test-Path -Path $InstallerLocation)) {
        # Download the installer
        $progressMsg = "InstallerLocation: '$InstallerLocation' not found - using default"
        Add-Content -Path C:\Packages\Plugins\gateway_log.txt -Value "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") $progressMsg"
        Write-Host($progressMsg)
        Install-DataGateway -AcceptConditions
    }
    else {
        # Use local installer
        $progressMsg = "InstallerLocation: '$InstallerLocation' found"
        Add-Content -Path C:\Packages\Plugins\gateway_log.txt -Value "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") $progressMsg"
        Write-Host($progressMsg)
        Install-DataGateway -AcceptConditions -InstallerLocation $InstallerLocation
    }
# }

# Due to a bug in the DataGeteway PS module only pass in the region to each command if we're not using the default
$defaultRegionKey = (Get-DataGatewayRegion | Where-Object {$_.IsDefaultPowerBIRegion -eq $true}).RegionKey
$progressMsg = "Default RegionKey: '$defaultRegionKey'"
Add-Content -Path C:\Packages\Plugins\gateway_log.txt -Value "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") $progressMsg"
Write-Host($progressMsg)   

# Only splat the RegionKey parameter if it's not been passed or is the default
$hostname = hostname
# if ($InstanceName -eq $hostname) {
#     $RegionKey = "uksouth"  # for the first index instace, region is UK south
# } else  {
#     $RegionKey = "northeurope"  # All of the rest of the instance is northeurope
# }

$regionKeyParam = @{}
if ((![string]::IsNullOrEmpty($RegionKey)) -and ($defaultRegionKey -ne $RegionKey)) {
    $regionKeyParam = @{
        RegionKey = $RegionKey
    }
    $progressMsg = "Creating Data Gateway Cluster: '$GatewayName' in RegionKey: '$RegionKey'"
} else  {
    $progressMsg = "Creating Data Gateway Cluster: '$GatewayName' in RegionKey: '$defaultRegionKey' (default)"
}
Add-Content -Path C:\Packages\Plugins\gateway_log.txt -Value "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") $progressMsg"
Write-Host($progressMsg)

# Create the Data Gateway Cluster, returning it's Id
# First check if this cluster already exists & get its ClusterId (not GatewayId)
$gatewayClusterId = $null
$gatewayClusterId = (Get-DataGatewayCluster @regionKeyParam | Where-Object { $_.Name -eq $GatewayName }).Id
if (($null -ne $gatewayClusterId) -and ($InstanceName -ne $hostname)) {
    $progressMsg = "Data Gateway Cluster name: '$GatewayName' already exists Cluster Id: '$gatewayClusterId'"
    Add-Content -Path C:\Packages\Plugins\gateway_log.txt -Value "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") $progressMsg"
    Write-Host($progressMsg)
} else {
    # Attempt to create cluster
    $gatewayClusterId = (Add-DataGatewayCluster @regionKeyParam -Name $GatewayName -RecoveryKey $secureRecoveryKey -OverwriteExistingGateway).GatewayObjectId   
    if ($null -ne $gatewayClusterId) {
        $progressMsg = "Data Gateway Cluster name: '$GatewayName' created Cluster Id: '$gatewayClusterId'"
        Add-Content -Path C:\Packages\Plugins\gateway_log.txt -Value "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") $progressMsg"
        Write-Host($progressMsg)
    }
}

# If problem during cluster creation or cluster missing we won't have a ClusterId
if ($null -eq $gatewayClusterId) {
    # Surface last error detail
    $lastError = Resolve-DataGatewayError -Last
    Add-Content -Path C:\Packages\Plugins\gateway_log.txt -Value "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") $progressMsg"
    Write-Host($lastError.Message)

    $progressMsg = "Error: Data Gateway Cluster not created or found, check if Gateway Name: '$GatewayName' already exists, the status and supplied RegionKey: '$RegionKey'"
    Add-Content -Path C:\Packages\Plugins\gateway_log.txt -Value "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") $progressMsg"
    Write-Error($progressMsg)
    exit 1
}

# Optionally add additional user as an admin for this data gateway
if (!([string]::IsNullOrEmpty($GatewayAdminUserIds))) {
    $GatewayAdminUserIdArray = $GatewayAdminUserIds -split ','
    $GatewayAdminUserIdArray.foreach{
        [GUID]$userGuid = $PSItem
        $progressMsg = "Adding Data Gateway admin user: '$userGuid'"
        Add-Content -Path C:\Packages\Plugins\gateway_log.txt -Value "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") $progressMsg"
        Write-Host($progressMsg)
        Add-DataGatewayClusterUser @regionKeyParam -GatewayClusterId $gatewayClusterId -PrincipalObjectId $userGuid -AllowedDataSourceTypes $null -Role Admin

        # Check the user was added ok
        if ((Get-DataGatewayCluster @regionKeyParam -Cluster $gatewayClusterId | Select-Object -ExpandProperty Permissions | Where-Object { $_.Id -eq $userGuid }).Length -ne 0) {
            $progressMsg = "Data Gateway admin user added"
            Add-Content -Path C:\Packages\Plugins\gateway_log.txt -Value "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") $progressMsg"
            Write-Host($progressMsg)
        }
        else {
            # Surface last error detail
            $lastError = Resolve-DataGatewayError -Last
            Add-Content -Path C:\Packages\Plugins\gateway_log.txt -Value "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") $progressMsg"
            Write-Host($lastError.Message)            

            $progressMsg = "Warning! Data Gateway admin user not added"
            # $logger.Log($progressMsg)
            Write-Warning($progressMsg)
        }
    }
} else {
    $progressMsg = "Warning! No additional Data Gateway admins have been set - you will only be able to use the AAD App credentials used to manage this cluster"
    Add-Content -Path C:\Packages\Plugins\gateway_log.txt -Value "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") $progressMsg"
    Write-Warning($progressMsg)
}

# Retrieve the cluster status
$cs = (Get-DataGatewayClusterStatus -GatewayClusterId $gatewayClusterId @regionKeyParam)
$progressMsg = "Cluster '$gatewayClusterId' ClusterStatus: '$($cs.ClusterStatus)' GatewayVersion: '$($cs.GatewayVersion)' GatewayUpgradeState: '$($cs.GatewayUpgradeState)'"
Add-Content -Path C:\Packages\Plugins\gateway_log.txt -Value "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") $progressMsg"
Write-Host($progressMsg)

# Status other than Live indicates issue
if ('Live' -ne $cs.ClusterStatus) {
    # Surface last error detail
    $lastError = Resolve-DataGatewayError -Last
    Add-Content -Path C:\Packages\Plugins\gateway_log.txt -Value "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") $progressMsg"
    Write-Host($lastError.Message)

    $progressMsg = "Error: Power BI Gateway not started!"
    Add-Content -Path C:\Packages\Plugins\gateway_log.txt -Value "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") $progressMsg"
    Write-Host($progressMsg)
    exit 1
}
else {
    $progressMsg = "Finished full_install_script.ps1"
    Add-Content -Path C:\Packages\Plugins\gateway_log.txt -Value "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") $progressMsg"
    Write-Host($progressMsg)
}

'@

iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI -Quiet"
Start-Process -FilePath "C:\Program Files\PowerShell\7\pwsh.exe" -ArgumentList "-NoExit -File C:\Packages\Plugins\full_install_script.ps1"
