$AutoMoxAccessKey = 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX'

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
if (Test-Path "C:\SW\"){
    if (Test-Path "C:\SW\Automox_Installer-latest.msi"){Remove-Item "C:\SW\Automox_Installer-latest.msi"}
    Invoke-WebRequest -UseBasicParsing -URI 'https://console.automox.com/installers/Automox_Installer-latest.msi' -OutFile "C:\SW\Automox_Installer-latest.msi"
}
else {
    New-Item -ItemType Directory -Path 'C:\SW\'
    Invoke-WebRequest -UseBasicParsing -URI 'https://console.automox.com/installers/Automox_Installer-latest.msi' -OutFile "C:\SW\Automox_Installer-latest.msi"
}

if (Test-Path "C:\SW\Automox_Installer-latest.msi"){
    msiexec.exe /i "C:\SW\Automox_Installer-latest.msi" /L*V "C:\SW\automox_install.log" /qn /norestart ACCESSKEY=$AutoMoxAccessKey
}
else {
    Write-Output "`n$(Get-Date -Format "MM/dd/yyyy HH:mm K"): Automox Installer failed to download." | Out-File -Append -FilePath "C:\SW\automox_install.log"
}