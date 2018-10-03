Param(
 [SecureString]$ASDKAdminUserPassword
)


$downloaderPath = "C:/ASDK/"
$filename = "azurestackdevkitdownloader.exe"
If (!(Test-Path $downloaderPath)) {
    New-Item -Path $downloaderPath -ItemType Directory
}

Invoke-WebRequest -Uri https://aka.ms/azurestackdevkitdownloader -OutFile ($downloaderPath + $filename) -Verbose

Write-Output ($env:ASDKAdminUserName)
Write-Output ($ASDKAdminUserPassword)

$Ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($ASDKAdminUserPassword)
$result = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($Ptr)
[System.Runtime.InteropServices.Marshal]::ZeroFreeCoTaskMemUnicode($Ptr)
$result


