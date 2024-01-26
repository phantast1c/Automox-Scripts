# Attach Setup.MBEndpointAgent.x64.msi to the worklet payload

Start-Process msiexec.exe -Wait -ArgumentList '/i Setup.MBEndpointAgent.x64.msi /quiet'
if (Test-Path "C:\Program Files\Malwarebytes Endpoint Agent\UserAgent\EACmd.exe"){
  Write-Output "Malwarebytes successfully installed!"; exit 0}
else {
  Write-Output "Malwarebytes installation failed..."; exit 1}