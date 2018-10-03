# Add to the TrustedHosts
Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value $("host1","host2") -force
