
# Install DataGateway module

# $hostname = hostname
# if (${instance_name} -eq $hostname) {

if (!(Get-InstalledModule "DataGateway" -ErrorAction SilentlyContinue)) {
    $progressMsg = "Installing DataGateway PS Module"
    Write-Host($progressMsg)
    Install-Module -Name DataGateway -Force -Scope AllUsers
}

$vaultName = ${kv_name}

# Connect to Data Gateway service account - below is MOJ tenant ID

$secret_password = (Get-AzKeyVaultSecret -VaultName $vaultName -Name "PowerBIUserPassword").SecretValue
$connect_username = "chirag.pareek@justice.gov.uk"

$connect_password = ConvertTo-SecureString $secret_password -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential -ArgumentList @($connect_username, $connect_password)

Connect-DataGatewayServiceAccount -Credential $credentials -Tenant c6874728-71e6-41fe-a9e1-2e8c36776ad8

# Download and install the latest gateway installer
Install-DataGateway -AcceptConditions

# Get the gateway cluster ID
$clusterId = (Get-DataGatewayCluster -Scope Individual).ClusterId

# Get the recovery key for the gateway cluster
$recoveryKey = (Get-DataGatewayClusterStatus -ClusterId $clusterId).RecoveryKey

$secretName = "DataGatewayRecoveryKey"

Set-AzKeyVaultSecret -VaultName $vaultName -Name $secretName -SecretValue $recoveryKey




# }

# # Get the recovery key from the key vault


# $recoveryKey = (Get-AzKeyVaultSecret -VaultName $vaultName -Name $secretName).SecretValue

# # Add the gateway to an existing cluster
# $gatewayName = "YourGatewayName"
# $regionKey = "YourRegionKey"
# Add-DataGatewayCluster -RecoveryKey $recoveryKey -GatewayName $gatewayName -RegionKey $regionKey -OverwriteExistingGateway
