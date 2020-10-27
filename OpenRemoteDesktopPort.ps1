<#
.SYNOPSIS
    Runbook to add a remote desktop endpoint on a virtual machine. 
    This script needs to be used along with recovery plans in Azure Site Recovery.

.DESCRIPTION
    This runbook provides you a way to open a remote desktop endpoint on your VM in a recovery plan.
    Create a ASR recovery plan for your application.
    For the virtual machine for which you want to open a public Azure endpoint to access the virtual machine
    over internet. Note that you can only use this script for one VM in your recovery plan.
    Place this script to run on the recovery side after the group in which you have placed the required VM.

    The required VM is identified in the script by specifying the $VMGUID. Identify the VM's GUID by going to the Properties page 
    in ASR and identifying the VMM VM GUID value. Place the value as a string below.

    For a similar script refer to http://azure.microsoft.com/en-us/documentation/articles/site-recovery-runbook-automation/
   
.PARAMETER Name
    RecoveryPlanContext is the only parameter you need to define.
    This parameter gets the failover context from the recovery plan.

.Dependencies and user configuration
    $VMGUID
    Specify the VM's VMM GUID in the variable $VMGUID.
    The script will identify the service name and the role name of the VM and create and endpoint for it.

    $AzureCredential
    Create a Asset Credential setting with the name AzureCredential
    Store the username passowrd of the account that has access to Azure subscription

    $AzureSubscriptionName
    Create an Asset String setting with the name AzureSubscriptionName
    Store your subscription name in this variable as a string
    
.NOTES
	Author: Ruturaj M. Dhekane - ruturajd@microsoft.com 
	Last Updated: 28/04/2015   
#>

workflow OpenRemoteDesktopPort
  { 
    param ( 
        [Object]$RecoveryPlanContext 
    ) 
 
    $Cred = Get-AutomationPSCredential -Name 'AzureCredential' 
 
    # Connect to Azure 
    $AzureAccount = Add-AzureAccount -Credential $Cred 
    $AzureSubscriptionName = Get-AutomationVariable –Name ‘AzureSubscriptionName’ 
    Select-AzureSubscription -SubscriptionName $AzureSubscriptionName 
 
    # Specify the parameters to be used by the script 
    $AEProtocol = "TCP" 
    $AELocalPort = 3389 
    $AEPublicPort = 3389 
    $AEName = "Remote desktop" 
    $VMGUID = "" 
 
    #Read the VM GUID from the context 
    $VM = $RecoveryPlanContext.VmMap.$VMGUID 
 
    if ($VM -ne $null) 
    { 
        # Invoke pipeline commands within an InlineScript 
 
        $EndpointStatus = InlineScript { 
            # Invoke the necessary pipeline commands to add a Azure Endpoint to a specified Virtual Machine 
            # This set of commands includes: Get-AzureVM | Add-AzureEndpoint | Update-AzureVM (including necessary parameters) 
 
            $Status = Get-AzureVM -ServiceName $Using:VM.CloudServiceName -Name $Using:VM.RoleName | ` 
                Add-AzureEndpoint -Name $Using:AEName -Protocol $Using:AEProtocol -PublicPort $Using:AEPublicPort -LocalPort $Using:AELocalPort | ` 
                Update-AzureVM 
            Write-Output $Status 
        } 
    } 
  }