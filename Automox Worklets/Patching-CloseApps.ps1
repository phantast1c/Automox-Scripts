$appsList = "notepad++","code"

foreach ($app in $appsList){
  # If process is running
  if(Get-Process -Name $app){
    # Running in job to wait for process to close before final check
    $job = Start-Job -ScriptBLock {Get-Process -Name $using:app | Stop-Process -Force -ErrorAction SilentlyContinue}
    Wait-Job $job | Out-Null
    
    # Debugging
    if(Get-Process -Name $app){Write-Output "ERROR: $app could not be closed..."}
    else{Write-Output "$app Successfully Closed"}
  }
}