# Onboard computer into Windows Defender
# Upload WindowsDefenderATPOnboardingScript.cmd to worklet payload

if ((Get-MpComputerStatus).AMRunningMode -eq "Not running"){
    # If not onboarded, run onboarding script
    Write-Output "This computer is not onboarded into Windows Defender ATP..."
    Write-Output "Attempting to onboard...`n"
    if ((Start-Process -FilePath ".\WindowsDefenderATPOnboardingScript.cmd" -WindowStyle Hidden -Wait -Passthru).ExitCode -eq 0){
      Write-Output "Windows Defender ATP Onboarding ran successfully!"
      exit 0
    }
    else {
      Write-Output "There was an error running the Windows Defender ATP Onboarding Script..."
      exit 1
    }
  }
else {
    Write-Output "This computer is already onboarded into Windows Defender ATP"
    exit 0
}