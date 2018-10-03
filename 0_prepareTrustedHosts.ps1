# Add to the TrustedHosts from Console Host
winrm set winrm/config/client '@{TrustedHosts="machineA,machineB"}'

# Allow PowerShell Remoting at ASDK Host
Set-WSManQuickConfig -Force