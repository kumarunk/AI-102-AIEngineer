@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

rem Set variable values 
set subscription_id=65d9ce7c-a52d-4364-9ee7-55f6a845c671
set resource_group=ai102
set location=australiaeast
set expiry_date=2024-01-01T00:00:00Z

rem Get random numbers to create unique resource names
set unique_id=!random!!random!

rem Create a storage account in your Azure resource group 
echo Creating storage...
call az storage account create --name ai102form!unique_id! --subscription !subscription_id! --resource-group !resource_group! --location !location! --sku Standard_LRS --encryption-services blob --default-action Allow --output none

echo Uploading files...
rem Get storage key to create a container in the storage account 
for /f "tokens=*" %%a in ( 
'az storage account keys list --subscription !subscription_id! --resource-group !resource_group! --account-name ai102form!unique_id! --query "[?keyName=='key1'].{keyName:keyName, permissions:permissions, value:value}"' 
) do ( 
set key_json=!key_json!%%a 
) 
set key_string=!key_json:[ { "keyName": "key1", "permissions": "Full", "value": "=!
set AZURE_STORAGE_KEY=!key_string:" } ]=!
rem Create container 
call az storage container create --account-name ai102form!unique_id! --name sampleforms --public-access blob --auth-mode key --account-key %AZURE_STORAGE_KEY% --output none
rem Upload files from your local sampleforms folder to a container called sampleforms in the storage account
rem Each file is uploaded as a blob 
call az storage blob upload-batch -d sampleforms -s ./sample-forms --account-name ai102form!unique_id! --auth-mode key --account-key %AZURE_STORAGE_KEY%  --output none
rem Set a variable value for future use 
set STORAGE_ACCT_NAME=ai102form!unique_id!

rem Get a Shared Access Signature (a signed URI that points to one or more storage resources) for the blobs in sampleforms   
for /f "tokens=*" %%a in (
'az storage container generate-sas --account-name ai102form!unique_id! --name sampleforms --expiry !expiry_date! --permissions rwl'
) do (
set SAS_TOKEN=%%a
set SAS_TOKEN=!SAS_TOKEN:~1,-1!
)
set URI=https://!STORAGE_ACCT_NAME!.blob.core.windows.net/sampleforms?!SAS_TOKEN!

rem Print the generated Shared Access Signature URI, which is used by Azure Storage to authorize access to the storage resource
echo -------------------------------------
echo SAS URI: !URI!
rem SAS URI: https://ai102form1648628182.blob.core.windows.net/sampleforms?se=2024-01-01T00%3A00%3A00Z&sp=rwl&sv=2021-06-08&sr=c&sig=%2Bbp/IB7idBH3Ed5BQxggFhhS0FxBKeilmGQppqTknwA%3D
rem model id: 3076aa5b-10db-4575-8127-97860b4e5fb9