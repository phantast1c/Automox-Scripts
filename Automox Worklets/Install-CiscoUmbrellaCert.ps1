# Downloads latest Cisco Umbrella Root CA and Installs to Local Machine Root
# Chrome and Edge will use local Certs but Firefox must be setup to accept Local certs

$ciscoUmbrellaCertUri = 'http://www.cisco.com/security/pki/certs/ciscoumbrellaroot.cer'
$certName = 'ciscoumbrellaroot.cer'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ffPolicyLocation = 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox\Certificates'

### Enabling Firefox ImportEnterpriseRoots ###
# Check for Firefox Reg Path
if (-not (Test-Path "$ffPolicyLocation")) {
    New-Item -Path "$ffPolicyLocation" -Force
}

# Will overwrite if policy exist
Write-Output "Enabling Firefox `"ImportEnterpriseRoots`"`n"
New-ItemProperty -Path $ffPolicyLocation -Name "ImportEnterpriseRoots" -Value 1 -PropertyType Dword -Force

### Downloading Cert and Importing ###
Invoke-WebRequest -Uri $ciscoUmbrellaCertUri -UseBasicParsing -OutFile $certName
Import-Certificate -File $certName -CertStoreLocation 'Cert:\LocalMachine\Root'
Remove-Item $certName

Write-Output "`nFinished importing the latest Cisco Umbrealla Root CA and enabling Firefox ImportEnterpriseRoots`n"
exit 0