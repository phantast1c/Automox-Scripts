<#
  .SYNOPSIS
      TeamViewer - Install Host & Assign
  .DESCRIPTION
      Installs TeamViewer Custom Host and Assigns device to Company
  .NOTES
      Modify the $tvCustomConfigID, $tvAssignmentID, $tvCurrVersion, and $tvURI variables as needed prior to use
#>

# TeamViewer Company Parameters
$tvCustomConfigID = 'TV_CUSTOM_CONFIG_ID'
$tvAssignmentID = 'TV_ASSIGNMENT_ID'

# TeamViewer Download Version
$tvCurrVersion = '15'
$tvURI = 'https://dl.teamviewer.com/download/version_' + $tvCurrVersion + 'x/TeamViewer_MSI64.zip'

function dlClean {
  # Make sure SW folder exist and cleans up stray TeamViewer downloads
  if (-not (Test-Path "C:\SW")){New-Item -Type Directory -Path C:\SW}
  Get-ChildItem -Path 'C:\SW' -Recurse -Include *teamviewer* | ForEach-Object {Remove-Item -Recurse -Path $_.FullName}
}

function dlTV {
  dlClean
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  $dlStatus = & {Invoke-WebRequest -UseBasicParsing -URI $tvURI -OutFile 'C:\SW\TeamViewer_MSI64.zip'} 2>&1
  if ($dlStatus){
    Write-Output "TeamViewer Download failed:"
    Write-Output "$dlStatus"
    exit 1
  }
  else {
    Expand-Archive -Path 'C:\SW\TeamViewer_MSI64.zip' -DestinationPath 'C:\SW\TeamViewer'
  }
}

function dlCheck {
  if (-not (Test-Path -Path 'C:\SW\TeamViewer\Host\TeamViewer_Host.msi')){
    Write-Output "TeamViewer Download and Extraction failed..."
    Write-Output "Missing TeamViewer_Host.msi"
    dlClean
    exit 1
  }
  if (-not (Test-Path -Path 'C:\SW\TeamViewer\Full\TeamViewer_Full.msi')){
    Write-Output "TeamViewer Download and Extraction failed..."
    Write-Output "Missing TeamViewer_Full.msi"
    dlClean
    exit 1
  }
}

function assignTV ($path){
  # The assignment command is ran twice to allow for device reassignment to the same account
  # Otherwise assignment fails if the device ID is already tied to the account
  Start-Process cmd -Wait -ArgumentList "/c `"$path`" assignment --id $tvAssignmentID"
  Start-Sleep 10
  Start-Process cmd -Wait -ArgumentList "/c `"$path`" assignment --id $tvAssignmentID"
}

dlTV
dlCheck

# Install TeamViewer Custom Host
Start-Process MSIEXEC.EXE -WorkingDirectory 'C:\SW\TeamViewer\Host'-Wait -ArgumentList "/i TeamViewer_Host.msi /qn CUSTOMCONFIGID=$tvCustomConfigID"

# Allow time for TeamViewer to start after install
Start-Sleep 30

dlClean

if (Test-Path "C:\Program Files\TeamViewer\TeamViewer.exe"){
  Write-Output "TeamViewer Host x64 detected. Running assignment command..."
  assignTV "C:\Program Files\TeamViewer\TeamViewer.exe"
  Write-Output "TeamViewer Host assignment command completed."
  Write-Output "Please check the TeamViewer Management Console to verify device assignment."
  exit 0
}
elseif (Test-Path "C:\Program Files (x86)\TeamViewer\TeamViewer.exe"){
  Write-Output "TeamViewer Host x84 detected. Running assignment command..."
  assignTV "C:\Program Files (x86)\TeamViewer\TeamViewer.exe"
  Write-Output "TeamViewer Host assignment command completed."
  Write-Output "Please check the TeamViewer Management Console to verify device assignment."
  exit 0
}
else {
  Write-Output "TeamViewer Host failed to install..."
  exit 1
}