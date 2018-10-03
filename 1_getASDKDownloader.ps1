# https://docs.microsoft.com/ja-jp/azure/azure-stack/azure-stack-deploy-overview

$downloaderPath = 'C:/ASDK/azurestackdevkitdownloader.exe'
Invoke-WebRequest -Uri https://aka.ms/azurestackdevkitdownloader -OutFile $downloaderPath -Verbose
