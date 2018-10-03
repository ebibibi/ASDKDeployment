# https://docs.microsoft.com/ja-jp/azure/azure-stack/azure-stack-deploy-overview

[System.IO.Path]::GetTempPath() | Tee-Object  -Variable installerPath
$installer = ($installerPath + "AzureStackDownloader.exe")
Write-Verbose "Installer path : $installer"
Invoke-WebRequest -Uri https://aka.ms/azurestackdevkitdownloader -OutFile $installer -Verbose
