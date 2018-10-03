# Add to the TrustedHosts
$ASDKHostIP = ""
Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value $($env:ASDKHostIP) -force
