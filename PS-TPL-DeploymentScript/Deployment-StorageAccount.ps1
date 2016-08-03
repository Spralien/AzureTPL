
$RmResourceGroupName = ""
$TemplatePath = "https://raw.githubusercontent.com/Spralien/AzureTPL/master/TPL-StorageAccount/azuredeploy.json"

$StorageAccountName = ""
$StorageAccountType = "Standard_LRS" # Standard_LRS, Standard_ZRS, Standard_GRS, Standard_RAGRS, Premium_LRS
$StorageAccountTier = "Standard" # Standard, Premium
$StorageAccountKind = "Storage" #Storage, BlobStorage 



$parameters = @{
    "StorageAccountName" = $StorageAccountName;
    "StorageAccountType" = $StorageAccountType;
    "StorageAccountTier" = $StorageAccountTier;
    "StorageAccountKind" = $StorageAccountKind
}
$test = Test-AzureRmResourceGroupDeployment -ResourceGroupName $RmResourceGroupName -TemplateFile $TemplatePath -TemplateParameterObject $parameters -Verbose 
Write-Host ($test | Format-List | Out-String)

if($test.Count -eq ''){ 
    New-AzureRmResourceGroupDeployment -ResourceGroupName $RmResourceGroupName -TemplateFile $TemplatePath -TemplateParameterObject $parameters -Verbose
}
