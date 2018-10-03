Param(
 [String]$ASDKAdminUserPassword
)

# Credential to ASDK Host
$password = ConvertTo-SecureString -String $ASDKAdminUserPassword -AsPlainText -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:ASDKAdminUserName, $password

# Boot from Physical Disks
$guid = $env:HDDBootGUID
Invoke-Command -ComputerName $env:ASDKHostIP -Credential $credential -ScriptBlock {
    bcdedit /default $using:guid
    shutdown -r
}
