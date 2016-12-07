workflow StartTaggedAzureVM2{
    
    param(
        [Parameter(Mandatory = $true)] 
        [string]$ResourceGroup,
        [Parameter(Mandatory = $true)] 
        [string]$CredentialAssetName,
        [Parameter(Mandatory = $false)] 
        [string]$SubscriptionID
    )

    $tagName = "AutoStart";
	$tagValue= "Y";
    $tagNameDays = "AutoStartDays";
    $CurrentDay = [int] (Get-Date).DayOfWeek;

    <# if($tagDaysValueArray -contains $CurrentDay){ #>
      
    #The name of the Automation Credential Asset this runbook will use to authenticate to Azure.
    #$CredentialAssetName = 'Sme_11_auto';
	
	#Get the credential with the above name from the Automation Asset store
    $Cred = Get-AutomationPSCredential -Name $CredentialAssetName;

    if(!$Cred) {
        Throw "Could not find an Automation Credential Asset named '${CredentialAssetName}'. Make sure you have created one in this Automation Account."
    }

    #Connect to your Azure Account
	$Account = Add-AzureRmAccount -Credential $Cred

    if(!$Account) {
        Throw "Could not authenticate to Azure using the credential asset '${CredentialAssetName}'. Make sure the user name and password are correct."
    }

    #$SubscriptionID = Get-AutomationVariable -Name $AzureSubscriptionID
    Select-AzureRmSubscription -SubscriptionId $SubscriptionID

    $VMs = Get-AzureRmVM -ResourceGroupName $ResourceGroup 
 
    # Stop VMs in parallel 
    if(!$VMs){
        Write-Output -InputObject 'No VMs were found in the specified Resource Group.'
    }
    else{
        $taggedRescources=Find-AzureRmResource  -TagName $tagName -TagValue $tagValue
            
        Foreach -parallel ( $vm in $taggedRescources ) {
            
            $CurrVM = Get-AzureRmVM -Name $vm.Name -ResourceGroupName $vm.resourceGroupName

            $day = (($CurrVM).Tags).$tagNameDays;

            if(!$day){
                $day = "1,2,3,4,5,6";
            }
            $tagDaysValueArray = $day -split ",";

            if($tagDaysValueArray -contains $CurrentDay) {
                Write-Output -InputObject "Starting $($vm.Name)";              
                Start-AzureRmVm -Name $vm.Name -ResourceGroupName $ResourceGroup;
            }
        }
    } 
}
