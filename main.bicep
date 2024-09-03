param location string = resourceGroup().location
param vmSize string = 'Standard_DS2_v2'
param adminUsername string
param adminPassword string

resource publicIP 'Microsoft.Network/publicIPAddresses@2021-08-01' = {
  name: 'myPublicIP'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    allocationMethod: 'Dynamic'
  }
}

resource vNet 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: 'myVNet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-08-01' = {
  parent: vNet
  name: 'default'
  properties: {
    addressPrefix: '10.0.1.0/24'
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-08-01' = {
  name: 'myNSG'
  location: location
  properties: {
    securityRules: [
      {
        name: 'RDP'
        properties: {
          priority: 300
          protocol: 'Tcp'
          direction: 'Inbound'
          access: 'Allow'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
        }
      }
    ]
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2021-08-01' = {
  name: 'myNIC'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnet.id
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIP.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsg.id
    }
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2021-08-01' = {
  name: 'myWindowsVM'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: 'myWindowsVM'
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        name: 'myOSDisk'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}
