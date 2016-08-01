
$RmResourceGroupName = ""
$TemplatePath = "https://raw.githubusercontent.com/Spralien/AzureTPL/master/TPL-VirtualNetwork-NetworkSecurity/azuredeploy.json"

$vnetName = "Vnet-coretest"
$vnetAddressPrefix = "10.0.0.0/16"
$subnet1Name = "Core" #Subnet 1 Name
$subnet1Prefix = "10.0.0.0/24" #Subnet 1 Prefix
$subnet2Name = "Subnet1" #Subnet 2 Name
$subnet2Prefix = "10.0.1.0/24" #Subnet 2 Prefix 
$networkSecurityGroupName = "networkSecurityGroup1"


$parameters = @{
    "vnetName" = $vnetName;
    "vnetAddressPrefix" = $vnetAddressPrefix;
    "subnet1Name" = $subnet1Name;
    "subnet1Prefix" = $subnet1Prefix;
    "subnet2Name" = $subnet2Name;
    "subnet2Prefix" = $subnet2Prefix;
    "networkSecurityGroupName" = $networkSecurityGroupName;
}
Test-AzureRmResourceGroupDeployment -ResourceGroupName $RmResourceGroupName -TemplateFile $TemplatePath -TemplateParameterObject $parameters
New-AzureRmResourceGroupDeployment -ResourceGroupName $RmResourceGroupName -TemplateFile $TemplatePath -TemplateParameterObject $parameters
