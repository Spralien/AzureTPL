
$RmResourceGroupName = ""
$TemplatePath = "https://raw.githubusercontent.com/Spralien/AzureTPL/master/TPL-AvailabilitySet/azuredeploy.json"

$nameOfAvailabilitySet = ""

$platformFaultDomainCount = 2 #1 - 3
$platformUpdateDomainCount = 2 # 1 - 20


$parameters = @{"AvailabilitySetName"=$nameOfAvailabilitySet; "platformFaultDomainCount" = $platformFaultDomainCount; "platformUpdateDomainCount" = $platformUpdateDomainCount}
$test = Test-AzureRmResourceGroupDeployment -ResourceGroupName $RmResourceGroupName -TemplateFile $TemplatePath -TemplateParameterObject $parameters -Verbose 
Write-Host ($test | Format-List | Out-String)

if($test.Count -eq ''){ 
    New-AzureRmResourceGroupDeployment -ResourceGroupName $RmResourceGroupName -TemplateFile $TemplatePath -TemplateParameterObject $parameters -Verbose
}
