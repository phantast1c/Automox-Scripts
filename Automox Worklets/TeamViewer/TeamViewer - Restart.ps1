<#
  .SYNOPSIS
      TeamViewer - Restart
  .DESCRIPTION
      Force closes and restarts the TeamViewer Service/App
  .NOTES
    
#>

Stop-Process -Name TeamViewer -Force -ErrorAction SilentlyContinue
& {Restart-Service -Name TeamViewer -Force} 2>&1 | Write-Output

$Test = Get-Service -Name TeamViewer

if ($Test.status -eq "Running"){
  Write-Output "TeamViewer sucessfully restarted!"
  exit 0
}
else {
  Write-Output "TeamViewer could not be restarted..."
  exit 1
}