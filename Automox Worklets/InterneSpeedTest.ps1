<#
  .SYNOPSIS
      Internet - Speed Test
  .DESCRIPTION
      Runs Ookla Speed Test and outputs the results
  .NOTES
      Upload the current speedtest.exe from Ookla into the Worklet Payload
      Download from https://www.speedtest.net/apps/cli
#>

$results = & .\speedtest_1.2.0.exe --accept-license
if ($results){
    Write-Output "Internet speed test completed!`n"
    Write-Output "Results:"
    
    # Writing each line seperate for report readability in Automox
    foreach ($line in $results){
        Write-Output "$line"
    }
    
    exit 0
}
else {
    Write-Output "Speed test could not be completed..."
    exit 1
}
