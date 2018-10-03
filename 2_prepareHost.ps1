Param(
 [String]$ASDKAdminUserPassword
)

# Add to the TrustedHosts
Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value $($env:ASDKHostIP) -force

# Copy CloudBuilder.vhdx to Host root
$password = ConvertTo-SecureString -String $ASDKAdminUserPassword -AsPlainText -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:ASDKAdminUserName, $password
$session = New-PSSession $env:ASDKHostIP -Credential $credential
Copy-Item -ToSession $session C:\test.txt -Destination C:\test.txt



#
#If (Test-Path "C:\CloudBuilder.vhdx") {
#    If (Test-Path "C:\ReBuildASDK\VHDXDownload\Azure Stack Development Kit\CloudBuilder.vhdx") {
#        Remove-Item "C:\CloudBuilder.vhdx" -Force
#    }
#}
#Move-Item "C:\ReBuildASDK\VHDXDownload\Azure Stack Development Kit\CloudBuilder.vhdx" C:\

# Variables
#$Uri = 'https://raw.githubusercontent.com/Azure/AzureStack-Tools/master/Deployment/asdk-installer.ps1'
#
#$LocalPath = 'C:\AzureStack_Installer'
#
#If (!(Test-Path $LocalPath)){
#    # Create folder
#    New-Item $LocalPath -Type directory
#}

# Enforce usage of TLSv1.2 to download from GitHub
#[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Download file
#Invoke-WebRequest $uri -OutFile ($LocalPath + '\' + 'asdk-installer.ps1')

# StartScript
#Set-Location $LocalPath
#.\asdk-installer.ps1
