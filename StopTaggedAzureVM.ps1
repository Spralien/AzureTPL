workflow StopTaggedAzureVM
{
	param(
     
        [Parameter(Mandatory = $true)] 
        [string]$ResourceGroup,
        [Parameter(Mandatory = $true)] 
        [string]$CredentialAssetName,
        [Parameter(Mandatory = $false)] 
        [string]$SubscriptionID
    
    )
	
    $tagName = "AUTOSTOP"
	$tagValue= "Y"
	
    
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
    if(!$VMs) 
    {
        Write-Output -InputObject 'No VMs were found in the specified Resource Group.'
    }
    else
    {
    $taggedRescources=Find-AzureRmResource  -TagName $tagName -TagValue $tagValue
    Foreach -parallel ( $vm in $taggedRescources ) {
            
            $CurrVM = Get-AzureRmVM -Name $vm.Name -ResourceGroupName $vm.resourceGroupName
            $skip = (($CurrVM).Tags).Skip      

            if($skip -ne "Y"){
                Write-Output -InputObject "Stopping $($vm.Name)";              
                Stop-AzureRmVm -Name $vm.Name -ResourceGroupName $ResourceGroup -Force; 
            }
            else {
                Write-Output -InputObject "Removing skip tagg from $($vm.Name)"; 
                #remove skip tag
                $currenttag = ($CurrVM).Tags    
                $tags=@()
                foreach ($tag in (Get-AzureRmResource -Name $vm.Name -resourceGroupName $ResourceGroup -ResourceType "Microsoft.Compute/virtualmachines").Tags){
			        if ($tag.Name -ne "skip"){
				        $tags+=$tag
                    }
                }
                $tags
                set-AzureRmResource -Name $vm.Name -resourceGroupName $ResourceGroup -ResourceType "Microsoft.Compute/VirtualMachines" -Tag $tags -Confirm:$false -Force
            }
        }
    }
}