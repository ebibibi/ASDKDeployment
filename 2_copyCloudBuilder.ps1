Param(
 [String]$ASDKAdminUserPassword
)

Write-Output $ASDKAdminUserPassword

# Open remote session to ASDK Host
$password = ConvertTo-SecureString -String $ASDKAdminUserPassword -AsPlainText -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:ASDKAdminUserName, $password
$session = New-PSSession $env:ASDKHostIP -Credential $credential -Verbose
$session

# Compare file hash
$localVHDPath = "C:\ASDK\AzureStackDevelopmentKit\CloudBuilder.vhdx"
$remoteVHDPath = "D:\ASDK\CloudBuilder.vhdx"

$localHash = Get-FileHash $localVHDPath
$remoteHash = Invoke-command -Session $session -scriptblock { Get-FileHash $using:remoteVHDPath }

If ($localHash.Hash -ne $remoteHash.Hash) {
  # Copy CloudBuilder.vhdx to ASDK Host
  Write-Verbose "Copy CloudBuilder.vhdx to ASDK Host"
  Copy-Item -ToSession $session $localvhd -Destination $remoteVHDPath
  } else {
    Write-Verbose "Copying CloudBuilder.vhd is canceled because Hash value is same."
    }
  
$session | Remove-PSSession
