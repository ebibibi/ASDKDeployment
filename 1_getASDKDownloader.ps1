$downloaderPath = "C:/ASDK/"
$filename = "azurestackdevkitdownloader.exe"
If (!(Test-Path $downloaderPath)) {
    New-Item -Path $downloaderPath -ItemType Directory
}

Invoke-WebRequest -Uri https://aka.ms/azurestackdevkitdownloader -OutFile ($downloaderPath + $filename) -Verbose

Write-Output ($env:ASDKAdminUserName)
Write-Output ($ASDKAdminUserPassword)


