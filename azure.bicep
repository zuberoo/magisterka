param adminUsername string
param adminPassword string
param vmCount int
param vmSize string
param storageAccountName string

var osDiskType = 'Standard_LRS'
var nicNamePrefix = 'myvm-nic'
var vmNamePrefix = 'myvm'



resource virtualMachines 'Microsoft.Compute/virtualMachines@2021-04-01' = 
[for i in range(0, vmCount): {
  name: '${vmNamePrefix}${i}'
  location: resourceGroup().location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: '${vmNamePrefix}${i}'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
      osDisk: {
        name: '${vmNamePrefix}${i}-osdisk'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: osDiskType
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', '${nicNamePrefix}${i}')
        }
      ]
    }
  }
}]

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }
}

resource networkInterfaces 'Microsoft.Network/networkInterfaces@2021-03-01' = 
[for i in range(0, vmCount): {
  name: '${nicNamePrefix}${i}'
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig${i}'
        properties: {
          subnet: {
            id: subnetRef('default')
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}]
