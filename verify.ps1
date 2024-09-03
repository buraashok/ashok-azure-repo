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

# Check if the public IP is assigned
$publicIP = Get-AzPublicIpAddress -ResourceGroupName $ResourceGroupName -Name 'myPublicIP' -ErrorAction SilentlyContinue
if (-not $publicIP) {
    Write-Host "Public IP 'myPublicIP' not found in Resource Group '$ResourceGroupName'."
    exit 1
}

# Check if the network interface is attached to the VM
$nic = Get-AzNetworkInterface -ResourceGroupName $ResourceGroupName -Name 'myNIC' -ErrorAction SilentlyContinue
if (-not $nic) {
    Write-Host "Network Interface 'myNIC' not found in Resource Group '$ResourceGroupName'."
    exit 1
}
elseif ($nic.VirtualMachine.Id -ne $vm.Id) {
    Write-Host "Network Interface 'myNIC' is not attached to Virtual Machine 'myWindowsVM'."
    exit 1
}

Write-Host "All resources deployed successfully!"
exit 0