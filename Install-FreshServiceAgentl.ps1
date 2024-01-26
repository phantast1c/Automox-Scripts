# Attach fs-windows-agent.msi to the worklet payload

Start-Process msiexec.exe -Wait -ArgumentList '/i fs-windows-agent.msi /quiet'
if (Test-Path "C:\Program Files (x86)\Freshdesk\Freshservice Discovery Agent"){
  Write-Output "Fresh Service Agent successfully installed!"; exit 0}
else {
  Write-Output "Fresh Service Agent installation failed..."; exit 1}