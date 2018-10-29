Param(
 [String]$ASDKAdminUserPassword
)

# Credential to ASDK Host
$password = ConvertTo-SecureString -String $ASDKAdminUserPassword -AsPlainText -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:ASDKAdminUserName, $password


# Wait for reboot
$hostname = $null
$session = $null
while($null -eq $session) {
    $session = New-PSSession -Credential $credential -ComputerName $env:ASDKHostIP -ErrorAction SilentlyContinue
    if($null -ne $session) {
        $hostname = Invoke-Command -Session $session -ScriptBlock {hostname}
    }
    
    if($hostname -ne $env:ASDKHostPhysicalName) {
        $session | Remove-PSSession
        $session = $null
    }

    Write-Output "Waiting for server reboot. Sleep more 30 sec."
    Start-Sleep 30
}

Write-Output "Connected to $hostname !!!"


Invoke-Command -Session $session -ScriptBlock {


    If (Test-Path "C:\CloudBuilder.vhdx") {
        If (Test-Path "C:\ASDK\Azure Stack Development Kit\CloudBuilder.vhdx") {
            Remove-Item "C:\CloudBuilder.vhdx" -Force
        }
    }
    Move-Item "C:\ASDK\Azure Stack Development Kit\CloudBuilder.vhdx" C:\

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
    #.\asdk-installer.ps1

}
