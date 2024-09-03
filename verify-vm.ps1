param (
    [string]$ResourceGroupName
)

# Check if the resource group exists
$rg = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
if (-not $rg) {
    Write-Host "Resource Group '$ResourceGroupName' not found."
    exit 1
}

# Check if the VM exists
$vm = Get-AzVM -ResourceGroupName $ResourceGroupName -Name 'myWindowsVM' -ErrorAction SilentlyContinue
if (-not $vm) {
    Write-Host "Virtual Machine 'myWindowsVM' not found in Resource Group '$ResourceGroupName'."
    exit 1
}

# ... (rest of the VM verification remains the same as before)

Write-Host "Windows VM deployed successfully!"
exit 0