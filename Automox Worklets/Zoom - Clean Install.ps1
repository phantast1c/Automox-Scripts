<#
  .SYNOPSIS
      Zoom - Clean Install
  .DESCRIPTION
      Cleanup existing Zoom installation and Install latest Zoom with your company as default SSO and enable auto updates
  .NOTES
      Modify the parameters as needed
#>

# Parameters
$zoomSSOHost = 'company.zoom.us'
$cleanZoomUri = 'https://assets.zoom.us/docs/msi-templates/CleanZoom.zip'
$zoomX64Uri = 'https://zoom.us/client/latest/ZoomInstallerFull.msi?archType=x64'
$downloadPath = 'C:\SW'
$zoomInstallPath = 'C:\Program Files\Zoom\bin\zoom.exe'

function zoomInstallerCleanup {
    Get-ChildItem -Path $downloadPath -Recurse -Include *zoom* -File | ForEach-Object {Remove-Item -Recurse -Path $($_.VersionInfo.FileName)}
}

# Download Latest Installers
function downloadZoom {
    zoomInstallerCleanup
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -UseBasicParsing -Uri $cleanZoomUri -OutFile "$downloadPath\CleanZoom.zip"
    Invoke-WebRequest -UseBasicParsing -Uri $zoomX64Uri -OutFile "$downloadPath\zoom-x64-latest.msi"
    Expand-Archive -Path "$downloadPath\CleanZoom.zip" -DestinationPath "$downloadPath\"
}

# Cleanup old Zoom installation and reinstall with Company parameters
function installZoom {
    if (Test-Path "$downloadPath\CleanZoom.exe"){
        Start-Process "$downloadPath\CleanZoom.exe" -Wait -ArgumentList '/silent'}
    else {
        Write-Output "CleanZoom.exe was not found..."; exit 1}
    if (Test-Path "$downloadPath\zoom-x64-latest.msi"){
        Start-Process -WorkingDirectory "$downloadPath" msiexec.exe -Wait -ArgumentList "/i zoom-x64-latest.msi ZoomAutoUpdate=1 zSSOHost=$zoomSSOHost zNoDesktopShortCut=True /qn /norestart /quiet"}
    else {
        Write-Output "zoom-x64-latest.msi was not found..."; exit 1}
}

# Make sure SW folder exsists
if (-not (Test-Path $downloadPath)){New-Item -Type Directory -Path $downloadPath}

# Check if Zoom is open
if (get-Process -Name Zoom -ErrorAction SilentlyContinue) {
    # Proceed if user has no active Zoom Meetings
    if ((Get-NetUDPEndpoint -OwningProcess (Get-Process -Name Zoom).Id -ErrorAction SilentlyContinue | Measure-Object).count  -eq 0){
        downloadZoom; installZoom}
    else {
        Write-Host "User is in a meeting, Zoom cleanup and installation stopped."; exit 1}}
else {
    downloadZoom; installZoom}

# Check for Zoom installation
if (Test-Path $zoomInstallPath){
    Write-Output "Zoom was installed successfully!"
    zoomInstallerCleanup; exit 0}
else {
    Write-Output "`nZoom Installation Failed..."
    zoomInstallerCleanup; exit 1}