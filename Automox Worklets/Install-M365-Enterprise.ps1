# Deploy Microsoft 365 with Office Deployment Tool
# Install M365 without Skype for Business
# Force close all M365 apps and update install to remove Skype for Business
# Upload deployment tool setup.exe and .xml config to worklet payload

$office = Start-Process '.\setup.exe' -ArgumentList '/configure .\M365-config.xml' -passthru
Wait-Process -Id $office.Id
Write-Output "Office Deployment Tool finished running!"
exit 0