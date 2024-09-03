param (
    [string]$ResourceGroupName
)

# Check if the resource group exists
$rg = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
if (-not $rg) {
    Write-Host "Resource Group '$ResourceGroupName' not found."
    exit 1
}

# Check if the SQL Server exists
$sqlServer = Get-AzSqlServer -ResourceGroupName $ResourceGroupName -ServerName "mySQLDBserver" -ErrorAction SilentlyContinue
if (-not $sqlServer) {
    Write-Host "Azure SQL Server 'mySQLDBserver' not found in Resource Group '$ResourceGroupName'."
    exit 1
}

# Check if the SQL Database exists
$sqlDatabase = Get-AzSqlDatabase -ResourceGroupName $ResourceGroupName -ServerName "mySQLDBserver" -DatabaseName "mySQLDB" -ErrorAction SilentlyContinue
if (-not $sqlDatabase) {
    Write-Host "Azure SQL Database 'mySQLDB' not found in Resource Group '$ResourceGroupName'."
    exit 1
}

Write-Host "Azure SQL Database deployed successfully!"
exit 0