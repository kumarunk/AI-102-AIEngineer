@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

rem Set values for your storage account
set subscription_id=65d9ce7c-a52d-4364-9ee7-55f6a845c671
set azure_storage_account=ai102cogsearchstore
set azure_storage_key=Cn8tRCy+cVHu8jnk6o0Oa8bhrtT1csoUnEjpqmpwPwS3hzADiCaLcH5Tl9cmAgAPc5UkbWIzaeqA+AStAV+E/Q==


echo Creating container...
call az storage container create --account-name !azure_storage_account! --subscription !subscription_id! --name margies --public-access blob --auth-mode key --account-key !azure_storage_key! --output none

echo Uploading files...
call az storage blob upload-batch -d margies -s data --account-name !azure_storage_account! --auth-mode key --account-key !azure_storage_key!  --output none
