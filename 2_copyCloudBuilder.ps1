Param(
 [String]$ASDKAdminUserPassword
)

Write-Output $ASDKAdminUserPassword

# Open remote session to ASDK Host
$password = ConvertTo-SecureString -String $ASDKAdminUserPassword -AsPlainText -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:ASDKAdminUserName, $password
$session = New-PSSession $env:ASDKHostIP -Credential $credential -Verbose
$session

# Copy CloudBuilder.vhdx to ASDK Host
Write-Verbose "Copy CloudBuilder.vhdx to Host"
Copy-Item -ToSession $session "C:\ASDK\AzureStackDevelopmentKit\CloudBuilder.vhdx" -Destination "D:\ASDK\CloudBuilder.vhdx" -

$session | Remove-PSSession
