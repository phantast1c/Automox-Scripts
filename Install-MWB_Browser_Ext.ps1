# Force installs Malwarebytes Browser Guard Extension and force pin to the nav bar
# Limitations:
#   Policy will apply upon browser restart
#   Edge Enterprise Browser: When logged into a enterprise account, the personal account side will not have MWB pinned
#   Firefox: MWB Extension will be pinned but will not be locked, user can unpin

$extChromeID = 'ihcjicgdanjaechkgeegckofjjedodee'
$extEdgeID = 'bojobppfploabceghnmlahpoonbcbacn'

$chromeRegForceLocation = 'HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist'
$chromeRegSettingLocation = 'HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionSettings'
$edgeRegForceLocation = 'HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist'
$edgeRegSettingLocation = 'HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionSettings'

$ffPolicyLocation = 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox'
$ffPolicy = @(
'{
    "{242af0bb-db11-4734-b7a0-61cb8a9b20fb}": {
    "installation_mode": "force_installed",
    "install_url": "https://addons.mozilla.org/firefox/downloads/latest/malwarebytes/latest.xpi",
    "default_area": "navbar"
}}'
)

######################
### Chrome Install ###
######################

# Check for Chrome Reg Path
if (-not (Test-Path "$chromeRegForceLocation")) {
    Write-Output "No Registry Path found for Chrome Extensions"
    [int]$chromeKeyCount = 0
    New-Item -Path "$chromeRegForceLocation" -Force
}
else {
    # Check for other extensions keys
    [int]$chromeKeyCount = (Get-Item "$chromeRegForceLocation").Property.Count
}

# Creating Chrome Extension Key
$regKey = $chromeKeyCount + 1
$regData = "$extChromeID;https://clients2.google.com/service/update2/crx"
$script:foundKey = $false
if ($chromeKeyCount -ne 0){$keyCheck = Get-Item -Path "$chromeRegForceLocation"}
foreach ($item in $keyCheck.property){
    $data = Get-ItemProperty -Path "$chromeRegForceLocation" -Name $item
    if ($data.$item -eq $regData){$script:foundKey = $true}
}

if (-not $script:foundKey){
    Write-Output "Creating Chrome reg key with Name`: $regKey and Data`: $regData"
    New-ItemProperty -Path "$chromeRegForceLocation" -Name $regKey -Value $regData -PropertyType String -Force
}

# Creating Chrome Extension Setting Key
# Will overwrite if key exists for given extension ID
if (-not (Test-Path "$chromeRegSettingLocation")){New-Item -Path "$chromeRegSettingLocation" -Force}
$extSettingData = '{"toolbar_pin":"force_pinned"}'
Write-Output "Creating Chrome Extension Setting Key $extSettingData`n"
New-ItemProperty -Path "$chromeRegSettingLocation" -Name $extChromeID -Value $extSettingData -PropertyType String -Force

####################
### Edge Install ###
####################

# Check for Edge Reg Path
if (-not (Test-Path "$edgeRegForceLocation")) {
    Write-Output "No Registry Path found for Edge Extensions"
    [int]$edgeKeyCount = 0
    New-Item -Path "$edgeRegForceLocation" -Force
}
else {
    # Check for other extensions keys
    [int]$edgeKeyCount = (Get-Item "$edgeRegForceLocation").Property.Count
}

# Creating Edge Extension Key 
$regKey = $edgeKeyCount + 1
$regData = "$extEdgeID;https://edge.microsoft.com/extensionwebstorebase/v1/crx"
$script:foundKey = $false
if ($edgeKeyCount -ne 0){$keyCheck = Get-Item -Path "$edgeRegForceLocation"}
foreach ($item in $keyCheck.property){
    $data = Get-ItemProperty -Path "$edgeRegForceLocation" -Name $item
    if ($data.$item -eq $regData){$script:foundKey = $true}
}

if (-not $script:foundKey){
    Write-Output "Creating Edge reg key with Name`: $regKey and Data`: $regData"
    New-ItemProperty -Path "$edgeRegForceLocation" -Name $regKey -Value $regData -PropertyType String -Force
}

# Creating Edge Extension Setting Key
# Will overwrite if key exists for given extension ID
if (-not (Test-Path "$edgeRegSettingLocation")){New-Item -Path "$edgeRegSettingLocation" -Force}
$extSettingData = '{"toolbar_state":"force_shown"}'
Write-Output "Creating Edge Extension Setting Key $extSettingData`n"
New-ItemProperty -Path "$edgeRegSettingLocation" -Name $extEdgeID -Value $extSettingData -PropertyType String -Force

#######################
### Firefox Install ###
#######################

# Check for Firefox Reg Path
if (-not (Test-Path "$ffPolicyLocation")) {
    New-Item -Path "$ffPolicyLocation" -Force
}

# Will overwrite if policy exist
Write-Output "Creating Firefox `"ExtensionSettings`"`n"
New-ItemProperty -Path $ffPolicyLocation -Name "ExtensionSettings" -Value $ffPolicy -PropertyType MultiString -Force


Write-Output "Finished adding browser extension policies!"
Write-Ouptut "Note`: Browsers have to be restart before policy takes effect."
exit 0