# First argument: Client identifier
param (
    [string]$ClientIdentifier
)

# Define directories and base config file
$KeyDir = "..\openvpn-ca\pki"
$OutputDir = ".\files"
$BaseConfig = ".\base.conf"
$OutputFile = Join-Path -Path $OutputDir -ChildPath "$ClientIdentifier.ovpn"

# Build the client configuration file
@"
$(Get-Content $BaseConfig -Raw)
<ca>
$(Get-Content "$KeyDir\ca.crt" -Raw)
</ca>
<cert>
$(Get-Content "$KeyDir\issued\$ClientIdentifier.crt" -Raw)
</cert>
<key>
$(Get-Content "$KeyDir\private\$ClientIdentifier.key" -Raw)
</key>
<tls-auth>
$(Get-Content "$KeyDir\ta.key" -Raw)
</tls-auth>
"@ | Set-Content -Path $OutputFile
