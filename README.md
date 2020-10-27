Open remote desktop port on a VM in a recovery plan
===================================================

            

 


 

 

 


 


This runbook provides you a way to open a remote desktop endpoint on your VM in a recovery plan.   


Create a ASR recovery plan for your application. For the virtual machine for which you want to open a public Azure endpoint to access the virtual machine over internet.


Note that you can only use this script for one VM in your recovery plan. Place this script to run on the recovery side after the group in which you have placed the required VM.


The required VM is identified in the script by specifying the $VMGUID. Identify the VM's GUID by going to the Properties page     in ASR and identifying the VMM VM GUID value. Place the value as a string below.


Modify the following configurations in your Azure Automation account before running the script


$VMGUID   


Specify the VM's VMM GUID in the variable $VMGUID. The script will identify the service name and the role name of the VM and create and endpoint for it.


$AzureCredential   


Create a Asset Credential setting with the name AzureCredential. Store the username passowrd of the account that has access to Azure subscription.


$AzureSubscriptionName   


Create an Asset String setting with the name AzureSubscriptionName. Store your subscription name in this variable as a string.



For a similar script refer to http://azure.microsoft.com/en-us/documentation/articles/site-recovery-runbook-automation/


 


This is just a sample script. After importing the script into your Azure Automation account you cvan change the script and its variables to suit your needs.


        
    
TechNet gallery is retiring! This script was migrated from TechNet script center to GitHub by Microsoft Azure Automation product group. All the Script Center fields like Rating, RatingCount and DownloadCount have been carried over to Github as-is for the migrated scripts only. Note : The Script Center fields will not be applicable for the new repositories created in Github & hence those fields will not show up for new Github repositories.
