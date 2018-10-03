Param(
 [String]$ASDKAdminUserPassword
)
# Open remote session to ASDK Host
$sessionname = "CloudBuilder Copy Session"
$session = Get-PSSession -Name $sessionname -ErrorAction SilentlyContinue

if($null -eq $session) {
    $password = ConvertTo-SecureString -String $ASDKAdminUserPassword -AsPlainText -Force
    $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:ASDKAdminUserName, $password
    $session = New-PSSession $env:ASDKHostIP -Credential $credential -Name $sessionname -Verbose
    $session    
}


$localVHDPath = "C:\ASDK\AzureStackDevelopmentKit\CloudBuilder.vhdx"
$localVHDFolderPath = "C:\ASDK\AzureStackDevelopmentKit"
$remoteVHDPath = "D:\ASDK\CloudBuilder.vhdx"
$remoteASDKPath = "D:\ASDK\"
$remoteShareName = "ASDK"

# Compare file hash
Write-Output "Get hash value of local file."
#$localHash = Get-FileHash $localVHDPath -Algorithm MD5 -Verbose
Write-Output "Get hash value of remote file."
#$remoteHash = Invoke-command -Session $session -scriptblock { Get-FileHash $using:remoteVHDPath -Algorithm MD5 -Verbose}

Write-Output "localhash"
Write-Output $localHash.Hash

Write-Output "remotehash"
Write-Output $remoteHash.Hash


#If ($localHash.Hash -ne $remoteHash.Hash) {
    # Copy CloudBuilder.vhdx to ASDK Host
    Write-Output "robocopy CloudBuilder.vhdx to ASDK Host"
    Invoke-Command $session -ScriptBlock {
        $ASDKShare = Get-SmbShare -Name $using:remoteShareName -ErrorAction SilentlyContinue
        if($null -eq $ASDKShare) {
            New-SmbShare -Name ASDK -Path $using:remoteASDKPath -FullAccess Everyone
        }        
    }

    if (-not (Test-Path z:\)) {
        New-PSDrive -Name z -PSProvider FileSystem -Root \\$env:ASDKHostIP\$remoteShareName -Credential $credential -Persist
    }

    New-PSDrive -Name z -PSProvider FileSystem -Root \\$env:ASDKHostIP\$remoteShareName -Credential $credential -Persist
    $scriptblock = {robocopy $localVHDFolderPath z:\ *.vhdx /r:1 /w:1 /z }
    . $scriptblock

#} else {
#    Write-Output "Copying CloudBuilder.vhd is canceled because Hash value is same(already copied)."
#}

$session | Remove-PSSession