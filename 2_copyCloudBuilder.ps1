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

Write-Output "Get hash value of local file."
$localHash = Get-FileHash $localVHDPath -Algorithm MD5 -Verbose
Write-Output "Get hash value of remote file."
$remoteHash = Invoke-command -Session $session -scriptblock { Get-FileHash $using:remoteVHDPath -Algorithm MD5 -Verbose}

Write-Output "localhash"
Write-Output $localHash.Hash

Write-Output "remotehash"
Write-Output $remoteHash.Hash

$jobname = "CloudBuilder Copy Job"

If ($localHash.Hash -ne $remoteHash.Hash) {
    # Copy CloudBuilder.vhdx to ASDK Host
    $copyjob = Get-Job -Name $jobname -ErrorAction SilentlyContinue
    if($null -eq $copyjob) {
        Write-Output "Kick Job for copying CloudBuilder.vhdx to ASDK Host"
        $copyjob = Start-Job -ScriptBlock {Copy-Item -ToSession $session $localvhdPath -Destination $remoteVHDPath -Verbose} -Name $jobname
    }

    # Wait for finish
    while(!($copyjob.Finished))
    {
        Write-Output "Waiting for finish copy CloudBuilder.vhdx"
        Start-Sleep -Seconds 60
    }
} else {
    Write-Output "Copying CloudBuilder.vhd is canceled because Hash value is same(already copied)."
}

$session | Remove-PSSession
