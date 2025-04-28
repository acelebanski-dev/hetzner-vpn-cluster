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
$(Get-Content $BaseConfig)
<ca>
$(Get-Content "$KeyDir\ca.crt")
</ca>
<cert>
$(Get-Content "$KeyDir\issued\$ClientIdentifier.crt")
</cert>
<key>
$(Get-Content "$KeyDir\private\$ClientIdentifier.key")
</key>
<tls-auth>
$(Get-Content "$KeyDir\ta.key")
</tls-auth>
"@ | Set-Content -Path $OutputFile
