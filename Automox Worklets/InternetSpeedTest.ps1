<#
  .SYNOPSIS
      Internet - Speed Test
  .DESCRIPTION
      Runs Ookla Speed Test and outputs the results
  .NOTES
      Parses and downloads the Win package from https://www.speedtest.net/apps/cli
#>

$dlPageURI = 'https://www.speedtest.net/apps/cli'

$dlPage = Invoke-WebRequest -UseBasicParsing -Uri $dlPageURI
$dlPageLinks = $dlPage.Links
$windlLink = $dlPageLinks | Where-Object {$_.outerHTML -match "Download for Windows"}

if ($windlLink.href.Count -eq 1){
    if ($windlLink.href -match ".zip"){
        $winPkgURI = $windlLink.href
    }
    else { 
        Write-Output "Ookla's Windows cli package download link could not be parsed from the download page..."
        Write-Output "The download webpage may have been changed. Consider revising the worklet."
        exit
    }
}
else {
    # Errors out if more than one link is found, website may have been changed
    Write-Output "Ookla's Windows cli package download link could not be parsed from the download page..."
    Write-Output "The download webpage may have been changed. Consider revising the worklet."
    exit
}


# Download Speed Test Win Package
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -UseBasicParsing -Uri $winPkgURI -OutFile ".\speedtest.zip"
Expand-Archive -Path ".\speedtest.zip" -DestinationPath ".\"

$results = & .\speedtest.exe --accept-license
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
    exit
}
