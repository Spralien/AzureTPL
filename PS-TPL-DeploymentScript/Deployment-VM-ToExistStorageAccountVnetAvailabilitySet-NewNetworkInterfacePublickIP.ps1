
$RmResourceGroupName = ""
$TemplatePath = "https://raw.githubusercontent.com/Spralien/AzureTPL/master/TPL-VM-ToExistStorageVnetAvailabilitySet-WithNetworkInterfacePublicIP/azuredeploy.json"

$VMName = "" #Name of the VM
$VMWindowsOSVersion = "2012-R2-Datacenter" # 2008-R2-SP, 2012-Datacenter, 2012-R2-Datacenter, Windows-Server-Technical-Preview
$vmSize = "Standard_D1"
$VMAdminUserName = ""
$StorageAccountName = "" #Name of a existing storage account to save OSdisk on. Need to be in same resource group
$VMStorageAccountContainerName = "osdisk" #Name of a existing or new storage blob container
$existingVirtualNetworkName = "" #Name of the existing VNET
$existingVirtualNetworkResourceGroup = "" #Name of the existing VNET resource group
$subnetName = "" #Name of the subnet in the virtual network you want to use
$dnsNameForPublicIP = "" #Unique DNS Name for the Public IP used to access the Virtual Machine
$availabilitySet = "" #Name of a existing availabilitySet


$parameters = @{
    "VMName" = $VMName;
    "VMWindowsOSVersion" = $VMWindowsOSVersion;
    "vmSize" = $vmSize;
    "VMAdminUserName" = $VMAdminUserName;
    "StorageAccountName" = $StorageAccountName;
    "VMStorageAccountContainerName" = $VMStorageAccountContainerName;
    "existingVirtualNetworkName" = $existingVirtualNetworkName;
    "existingVirtualNetworkResourceGroup" = $existingVirtualNetworkResourceGroup;
    "subnetName" = $subnetName;
    "dnsNameForPublicIP" = $dnsNameForPublicIP;
    "availabilitySetName" = $availabilitySet
}
Test-AzureRmResourceGroupDeployment -ResourceGroupName $RmResourceGroupName -TemplateFile $TemplatePath -TemplateParameterObject $parameters
New-AzureRmResourceGroupDeployment -ResourceGroupName $RmResourceGroupName -TemplateFile $TemplatePath -TemplateParameterObject $parameters

