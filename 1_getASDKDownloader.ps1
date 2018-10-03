# https://docs.microsoft.com/ja-jp/azure/azure-stack/azure-stack-deploy-overview

$downloaderPath = "C:/ASDK/"
$filename = "azurestackdevkitdownloader.exe"
If (!(Test-Path $downloaderPath)) {
    New-Item -Path $downloaderPath -ItemType Directory
}

Invoke-WebRequest -Uri https://aka.ms/azurestackdevkitdownloader -OutFile ($downloaderPath + $filename) -Verbose

Write-Host ($env:ASDKAdminUserName)
Write-Output ($env:ASDKAdminUserName)

