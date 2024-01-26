# https://service.malwarebytes.com/hc/en-us/articles/16660990749331
# Upload mb-clean.exe to worklet payload
# Set your Malwarebytes Endpoint Password to $mwbepw within the worklet

if (-not (Test-Path "C:\Program Files\Malwarebytes Endpoint Agent\UserAgent\EACmd.exe")){
    Write-Output "Malwarebytes was is not installed."; exit 0}
else {
    # Running different mb-clean instances to make sure all installation cases are covered
    Start-Process .\mb-clean.exe -Wait -ArgumentList "/y /cleanup /noreboot /nopr /epatamperpw `"$mwbepw`""
    Start-Process .\mb-clean.exe -Wait -ArgumentList '/y /cleanup /noreboot /nopr /epatoken "NoTamperProtection"'
    Start-Process .\mb-clean.exe -Wait -ArgumentList '/y /cleanup /noreboot /nopr'

    # Clean up stray files
    $mwbPaths = ( `
    'C:\Program Files\Malwarebytes Endpoint Agent', `
    'C:\ProgramData\Malwarebytes Endpoint Agent', `
    'C:\Program Files\Malwarebytes', `
    'C:\ProgramData\Malwarebytes')
    
    Foreach ($Path in $mwbPaths ){
        if (Test-Path $path){Remove-Item -Recurse -Force -Path $Path}
    }
    Get-ChildItem C:\ProgramData\Malwarebytes -Recurse | Remove-Item -Recurse -Force

    # Final Checks
    if (-not (Test-Path "C:\Program Files\Malwarebytes Endpoint Agent")){
        Write-Output "Malwarebytes successfully uninstalled!"; exit 0}
    else {
        Write-Output "Malwarebytes uninstall failed..."; exit 1}
}