package test

import (
	"testing"
	"strings"
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestAzureResources(t *testing.T) {
	
	terraformOptions := &terraform.Options{
		TerraformDir: "../Terraform-azure-1.tf",
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	
	expectedStorageAccountName := "Terraform-Magisterka"
	exists := azure.StorageAccountExists(t, expectedStorageAccountName, "BB-praca-magisterka", "subscription_id")
	assert.True(t, exists, "Storage account does not exist")

	
	for i := 1; i <= 5; i++ {
		vmName := strings.Join(["your_vm_name_prefix", string(i)], "_")
		
		
		exists := azure.VirtualMachineExists(t, vmName, "BB-praca-magisterka", "subscription_id")
		assert.True(t, exists, "VM with name %s does not exist", vmName)

		
		size := azure.GetSizeOfVirtualMachine(t, vmName, "BB-praca-magisterka", "subscription_id")
		assert.Equal(t, "Standard_DS2_v2", size, "VM %s has incorrect size", vmName)
		
		
		os := azure.GetVirtualMachineOS(t, vmName, "BB-praca-magisterka", "subscription_id")
		assert.Equal(t, "expected_os_name", os, "VM %s has incorrect OS", vmName)

		
		diskSize := azure.GetDiskSizeOfVirtualMachine(t, vmName, "BB-praca-magisterka", "subscription_id")
		assert.Equal(t, expectedDiskSize, diskSize, "VM %s has incorrect disk size", vmName)

		
		isEncrypted := azure.IsDiskEncrypted(t, vmName, "BB-praca-magisterka", "subscription_id")
		assert.True(t, isEncrypted, "Disk for VM %s is not encrypted", vmName)

		assert.True(t, azure.VirtualMachineHasDiagnosticsProfile(t, vmName, resourceGroupName, subscriptionID))

		backupPolicy := azure.GetVirtualMachineBackupPolicy(t, vmName, resourceGroupName, subscriptionID)
        assert.NotEqual(t, "", backupPolicy, "No backup policy set for VM "+vmName)
	}

	
	exists := azure.ResourceGroupExists(t, resourceGroupName, subscriptionID)
	assert.True(t, exists, "Resource group does not exist")

	assert.True(t, azure.StorageAccountExists(t, storageAccountName, resourceGroupName, subscriptionID), "Storage account does not exist")

	assert.False(t, azure.StorageAccountAllowsPublicAccess(t, storageAccountName, resourceGroupName, subscriptionID))

}
