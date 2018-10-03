Write-Host ($env:ASDKAdminUserName)
Write-Output ($env:ASDKAdminUserName)

# Copy CloudBuilder.vhdx to Host root


If (Test-Path "C:\CloudBuilder.vhdx") {
    If (Test-Path "C:\ReBuildASDK\VHDXDownload\Azure Stack Development Kit\CloudBuilder.vhdx") {
        Remove-Item "C:\CloudBuilder.vhdx" -Force
    }
}
Move-Item "C:\ReBuildASDK\VHDXDownload\Azure Stack Development Kit\CloudBuilder.vhdx" C:\

# Variables
$Uri = 'https://raw.githubusercontent.com/Azure/AzureStack-Tools/master/Deployment/asdk-installer.ps1'

$LocalPath = 'C:\AzureStack_Installer'

If (!(Test-Path $LocalPath)){
    # Create folder
    New-Item $LocalPath -Type directory
}

# Enforce usage of TLSv1.2 to download from GitHub
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Download file
Invoke-WebRequest $uri -OutFile ($LocalPath + '\' + 'asdk-installer.ps1')

# StartScript
Set-Location $LocalPath
.\asdk-installer.ps1