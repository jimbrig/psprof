#Requires -Version 3.0

<#PSScriptInfo

.VERSION 1.0.1

.GUID c98fc2ce-fe63-4b07-9ed2-5a0fdaf208ae

.AUTHOR Jimmy Briggs

.COMPANYNAME jimbrig

.COPYRIGHT Jimmy Briggs | 2023

.TAGS Fonts Installation Nerd-Font Admin Design Machine Settings Utility Setup

.LICENSEURI https://github.com/jimbrig/PSScripts/blob/main/LICENSE

.PROJECTURI https://github.com/jimbrig/PSScripts/Install-NerdFont/

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Initial Release

.PRIVATEDATA

#>

<#
.SYNOPSIS
    Installs the provided fonts.
.DESCRIPTION
    Installs all the provided fonts by default.  The FontName
    parameter can be used to pick a subset of fonts to install.
.EXAMPLE
    C:\PS> ./install.ps1
    Installs all the fonts located in the Git repository.
.EXAMPLE
    C:\PS> ./install.ps1 FiraCode, Hack
    Installs all the FiraCode and Hack fonts.
.EXAMPLE
    C:\PS> ./install.ps1 CascadiaCode -WindowsCompatibleOnly
    Filters fonts to include only those labeled as 'Windows Compatible'
    Can be used in combination with the -FontName and/or -WhatIf parameters
.EXAMPLE
    C:\PS> ./install.ps1 DejaVuSansMono -WhatIf
    Shows which fonts would be installed without actually installing the fonts.
    Remove the "-WhatIf" to install the fonts.
#>
[CmdletBinding(SupportsShouldProcess)]
param (
    [switch]$WindowsCompatibleOnly
)

dynamicparam {
    $Attributes = [Collections.ObjectModel.Collection[Attribute]]::new()
    $ParamAttribute = [Parameter]::new()
    $ParamAttribute.Position = 0
    $ParamAttribute.ParameterSetName = '__AllParameterSets'
    $Attributes.Add($ParamAttribute)

    [string[]]$FontNames = Join-Path $PSScriptRoot patched-fonts | Get-ChildItem -Directory -Name
    $Attributes.Add([ValidateSet]::new(($FontNames)))

    $Parameter = [Management.Automation.RuntimeDefinedParameter]::new('FontName',  [string[]], $Attributes)
    $RuntimeParams = [Management.Automation.RuntimeDefinedParameterDictionary]::new()
    $RuntimeParams.Add('FontName', $Parameter)

    return $RuntimeParams
}

end {
    $FontName = $PSBoundParameters.FontName
    if (-not $FontName) {$FontName = '*'}

    $fontFiles = [Collections.Generic.List[System.IO.FileInfo]]::new()

    Join-Path $PSScriptRoot patched-fonts | Push-Location
    foreach ($aFontName in $FontName) {
        Get-ChildItem $aFontName -Recurse | Where-Object {
            $IsValidFileExtension = $_.Extension -match 'ttf|otf'

            if ($WindowsCompatibleOnly) {
                $IsValidFileExtension -and ($_.BaseName -match 'Windows Compatible')
            } else {
                $IsValidFileExtension
            }
        } | ForEach-Object {
            $fontFiles.Add($_)
        }
    }
    Pop-Location

    $fonts = $null
    foreach ($fontFile in $fontFiles) {
        if ($PSCmdlet.ShouldProcess($fontFile.Name, "Install Font")) {
            if (!$fonts) {
                $shellApp = New-Object -ComObject shell.application
                $fonts = $shellApp.NameSpace(0x14)
            }
            $fonts.CopyHere($fontFile.FullName)
        }
    }
}

# SIG # Begin signature block
# MIIbsQYJKoZIhvcNAQcCoIIbojCCG54CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBvchbK5VZFmiuC
# ByYlbU2Qk+9zriUM8/9yUPaDSiAeMaCCFgcwggL8MIIB5KADAgECAhBvRxLIstso
# kkFFgS0muvCbMA0GCSqGSIb3DQEBCwUAMBYxFDASBgNVBAMMC0ppbUJyaWdEZXZ0
# MB4XDTIzMDMxMDIzMjY1NVoXDTI0MDMxMDIzNDY1NVowFjEUMBIGA1UEAwwLSmlt
# QnJpZ0RldnQwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDHDgwOjMvc
# sURWKCDgflsMLhNRIA5yWwkkwCSRTb2jPZTniUkPGgdJy8XQRXoecakq9Cw5QS2x
# UeCwVw+om9b4TeHdcZP237tLwJzMVf38xEfE7pE4jZHqcWd4owLtuD9oB//1nkiy
# FqiVBVgsOyRy4YJmwvhtbmA5ZWW1WHkNOgnh4ZPEBdLIIwsZlQT8B5aTHZQCj2YX
# NgUeroPJH0WgVajI4FDvN3usL8m3uh0UvE82nBgkJ5dkuVxHB2U3G4FN6nVb7N2y
# 4urqwBG/L8R04vI/IYYSEj2wxZb1swF5BJ22opDauWFdFQ7sN4qpElNMb6teAG7M
# qW6FK+eSLrJ1AgMBAAGjRjBEMA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggr
# BgEFBQcDAzAdBgNVHQ4EFgQUacXlY5TOFBx5jUTmblh9+x5NcSUwDQYJKoZIhvcN
# AQELBQADggEBALbBLxYxORHVIHbZELfnX89QPM3+uKs0/SVWD7tiSa2HRPBDPSo1
# xFC2k/FzkzXaNXatKj1+4S/W/2tbOv7AM9a8t5luZeRZcRrfhaM+MHlN31ATBDMB
# ENMFt3iA70ToY5yRdVBaBsoA0FVvdmaIK/NsfwfU0hqz891w5bgYV4JFju832e19
# yoDqTXWmQUaAxFDQhL8I08y/cWTSxicRNdfEmn9ySV+QBrd76CV4F49nWWK9gcvP
# Ja2cOHxWb1EWW2yBC54aVOKidI+CzlYBYYeZZpRtkTseirvxoMt34b8iajKKqPlr
# VPNjRcQxLgfT841f49girM/UA4gtKgXBexYwggWNMIIEdaADAgECAhAOmxiO+dAt
# 5+/bUOIIQBhaMA0GCSqGSIb3DQEBDAUAMGUxCzAJBgNVBAYTAlVTMRUwEwYDVQQK
# EwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAiBgNV
# BAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0yMjA4MDEwMDAwMDBa
# Fw0zMTExMDkyMzU5NTlaMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2Vy
# dCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lD
# ZXJ0IFRydXN0ZWQgUm9vdCBHNDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoC
# ggIBAL/mkHNo3rvkXUo8MCIwaTPswqclLskhPfKK2FnC4SmnPVirdprNrnsbhA3E
# MB/zG6Q4FutWxpdtHauyefLKEdLkX9YFPFIPUh/GnhWlfr6fqVcWWVVyr2iTcMKy
# unWZanMylNEQRBAu34LzB4TmdDttceItDBvuINXJIB1jKS3O7F5OyJP4IWGbNOsF
# xl7sWxq868nPzaw0QF+xembud8hIqGZXV59UWI4MK7dPpzDZVu7Ke13jrclPXuU1
# 5zHL2pNe3I6PgNq2kZhAkHnDeMe2scS1ahg4AxCN2NQ3pC4FfYj1gj4QkXCrVYJB
# MtfbBHMqbpEBfCFM1LyuGwN1XXhm2ToxRJozQL8I11pJpMLmqaBn3aQnvKFPObUR
# WBf3JFxGj2T3wWmIdph2PVldQnaHiZdpekjw4KISG2aadMreSx7nDmOu5tTvkpI6
# nj3cAORFJYm2mkQZK37AlLTSYW3rM9nF30sEAMx9HJXDj/chsrIRt7t/8tWMcCxB
# YKqxYxhElRp2Yn72gLD76GSmM9GJB+G9t+ZDpBi4pncB4Q+UDCEdslQpJYls5Q5S
# UUd0viastkF13nqsX40/ybzTQRESW+UQUOsxxcpyFiIJ33xMdT9j7CFfxCBRa2+x
# q4aLT8LWRV+dIPyhHsXAj6KxfgommfXkaS+YHS312amyHeUbAgMBAAGjggE6MIIB
# NjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBTs1+OC0nFdZEzfLmc/57qYrhwP
# TzAfBgNVHSMEGDAWgBRF66Kv9JLLgjEtUYunpyGd823IDzAOBgNVHQ8BAf8EBAMC
# AYYweQYIKwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdp
# Y2VydC5jb20wQwYIKwYBBQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNv
# bS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcnQwRQYDVR0fBD4wPDA6oDigNoY0
# aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENB
# LmNybDARBgNVHSAECjAIMAYGBFUdIAAwDQYJKoZIhvcNAQEMBQADggEBAHCgv0Nc
# Vec4X6CjdBs9thbX979XB72arKGHLOyFXqkauyL4hxppVCLtpIh3bb0aFPQTSnov
# Lbc47/T/gLn4offyct4kvFIDyE7QKt76LVbP+fT3rDB6mouyXtTP0UNEm0Mh65Zy
# oUi0mcudT6cGAxN3J0TU53/oWajwvy8LpunyNDzs9wPHh6jSTEAZNUZqaVSwuKFW
# juyk1T3osdz9HNj0d1pcVIxv76FQPfx2CWiEn2/K2yCNNWAcAgPLILCsWKAOQGPF
# mCLBsln1VWvPJ6tsds5vIy30fnFqI2si/xK4VC0nftg62fC2h5b9W9FcrBjDTZ9z
# twGpn1eqXijiuZQwggauMIIElqADAgECAhAHNje3JFR82Ees/ShmKl5bMA0GCSqG
# SIb3DQEBCwUAMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMx
# GTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0IFRy
# dXN0ZWQgUm9vdCBHNDAeFw0yMjAzMjMwMDAwMDBaFw0zNzAzMjIyMzU5NTlaMGMx
# CzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE7MDkGA1UEAxMy
# RGlnaUNlcnQgVHJ1c3RlZCBHNCBSU0E0MDk2IFNIQTI1NiBUaW1lU3RhbXBpbmcg
# Q0EwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDGhjUGSbPBPXJJUVXH
# JQPE8pE3qZdRodbSg9GeTKJtoLDMg/la9hGhRBVCX6SI82j6ffOciQt/nR+eDzMf
# UBMLJnOWbfhXqAJ9/UO0hNoR8XOxs+4rgISKIhjf69o9xBd/qxkrPkLcZ47qUT3w
# 1lbU5ygt69OxtXXnHwZljZQp09nsad/ZkIdGAHvbREGJ3HxqV3rwN3mfXazL6IRk
# tFLydkf3YYMZ3V+0VAshaG43IbtArF+y3kp9zvU5EmfvDqVjbOSmxR3NNg1c1eYb
# qMFkdECnwHLFuk4fsbVYTXn+149zk6wsOeKlSNbwsDETqVcplicu9Yemj052FVUm
# cJgmf6AaRyBD40NjgHt1biclkJg6OBGz9vae5jtb7IHeIhTZgirHkr+g3uM+onP6
# 5x9abJTyUpURK1h0QCirc0PO30qhHGs4xSnzyqqWc0Jon7ZGs506o9UD4L/wojzK
# QtwYSH8UNM/STKvvmz3+DrhkKvp1KCRB7UK/BZxmSVJQ9FHzNklNiyDSLFc1eSuo
# 80VgvCONWPfcYd6T/jnA+bIwpUzX6ZhKWD7TA4j+s4/TXkt2ElGTyYwMO1uKIqjB
# Jgj5FBASA31fI7tk42PgpuE+9sJ0sj8eCXbsq11GdeJgo1gJASgADoRU7s7pXche
# MBK9Rp6103a50g5rmQzSM7TNsQIDAQABo4IBXTCCAVkwEgYDVR0TAQH/BAgwBgEB
# /wIBADAdBgNVHQ4EFgQUuhbZbU2FL3MpdpovdYxqII+eyG8wHwYDVR0jBBgwFoAU
# 7NfjgtJxXWRM3y5nP+e6mK4cD08wDgYDVR0PAQH/BAQDAgGGMBMGA1UdJQQMMAoG
# CCsGAQUFBwMIMHcGCCsGAQUFBwEBBGswaTAkBggrBgEFBQcwAYYYaHR0cDovL29j
# c3AuZGlnaWNlcnQuY29tMEEGCCsGAQUFBzAChjVodHRwOi8vY2FjZXJ0cy5kaWdp
# Y2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNydDBDBgNVHR8EPDA6MDig
# NqA0hjJodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9v
# dEc0LmNybDAgBgNVHSAEGTAXMAgGBmeBDAEEAjALBglghkgBhv1sBwEwDQYJKoZI
# hvcNAQELBQADggIBAH1ZjsCTtm+YqUQiAX5m1tghQuGwGC4QTRPPMFPOvxj7x1Bd
# 4ksp+3CKDaopafxpwc8dB+k+YMjYC+VcW9dth/qEICU0MWfNthKWb8RQTGIdDAiC
# qBa9qVbPFXONASIlzpVpP0d3+3J0FNf/q0+KLHqrhc1DX+1gtqpPkWaeLJ7giqzl
# /Yy8ZCaHbJK9nXzQcAp876i8dU+6WvepELJd6f8oVInw1YpxdmXazPByoyP6wCeC
# RK6ZJxurJB4mwbfeKuv2nrF5mYGjVoarCkXJ38SNoOeY+/umnXKvxMfBwWpx2cYT
# gAnEtp/Nh4cku0+jSbl3ZpHxcpzpSwJSpzd+k1OsOx0ISQ+UzTl63f8lY5knLD0/
# a6fxZsNBzU+2QJshIUDQtxMkzdwdeDrknq3lNHGS1yZr5Dhzq6YBT70/O3itTK37
# xJV77QpfMzmHQXh6OOmc4d0j/R0o08f56PGYX/sr2H7yRp11LB4nLCbbbxV7HhmL
# NriT1ObyF5lZynDwN7+YAN8gFk8n+2BnFqFmut1VwDophrCYoCvtlUG3OtUVmDG0
# YgkPCr2B2RP+v6TR81fZvAT6gt4y3wSJ8ADNXcL50CN/AAvkdgIm2fBldkKmKYcJ
# RyvmfxqkhQ/8mJb2VVQrH4D6wPIOK+XW+6kvRBVK5xMOHds3OBqhK/bt1nz8MIIG
# wDCCBKigAwIBAgIQDE1pckuU+jwqSj0pB4A9WjANBgkqhkiG9w0BAQsFADBjMQsw
# CQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xOzA5BgNVBAMTMkRp
# Z2lDZXJ0IFRydXN0ZWQgRzQgUlNBNDA5NiBTSEEyNTYgVGltZVN0YW1waW5nIENB
# MB4XDTIyMDkyMTAwMDAwMFoXDTMzMTEyMTIzNTk1OVowRjELMAkGA1UEBhMCVVMx
# ETAPBgNVBAoTCERpZ2lDZXJ0MSQwIgYDVQQDExtEaWdpQ2VydCBUaW1lc3RhbXAg
# MjAyMiAtIDIwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDP7KUmOsap
# 8mu7jcENmtuh6BSFdDMaJqzQHFUeHjZtvJJVDGH0nQl3PRWWCC9rZKT9BoMW15GS
# OBwxApb7crGXOlWvM+xhiummKNuQY1y9iVPgOi2Mh0KuJqTku3h4uXoW4VbGwLpk
# U7sqFudQSLuIaQyIxvG+4C99O7HKU41Agx7ny3JJKB5MgB6FVueF7fJhvKo6B332
# q27lZt3iXPUv7Y3UTZWEaOOAy2p50dIQkUYp6z4m8rSMzUy5Zsi7qlA4DeWMlF0Z
# Wr/1e0BubxaompyVR4aFeT4MXmaMGgokvpyq0py2909ueMQoP6McD1AGN7oI2TWm
# tR7aeFgdOej4TJEQln5N4d3CraV++C0bH+wrRhijGfY59/XBT3EuiQMRoku7mL/6
# T+R7Nu8GRORV/zbq5Xwx5/PCUsTmFntafqUlc9vAapkhLWPlWfVNL5AfJ7fSqxTl
# OGaHUQhr+1NDOdBk+lbP4PQK5hRtZHi7mP2Uw3Mh8y/CLiDXgazT8QfU4b3ZXUtu
# MZQpi+ZBpGWUwFjl5S4pkKa3YWT62SBsGFFguqaBDwklU/G/O+mrBw5qBzliGcnW
# hX8T2Y15z2LF7OF7ucxnEweawXjtxojIsG4yeccLWYONxu71LHx7jstkifGxxLjn
# U15fVdJ9GSlZA076XepFcxyEftfO4tQ6dwIDAQABo4IBizCCAYcwDgYDVR0PAQH/
# BAQDAgeAMAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwIAYD
# VR0gBBkwFzAIBgZngQwBBAIwCwYJYIZIAYb9bAcBMB8GA1UdIwQYMBaAFLoW2W1N
# hS9zKXaaL3WMaiCPnshvMB0GA1UdDgQWBBRiit7QYfyPMRTtlwvNPSqUFN9SnDBa
# BgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNl
# cnRUcnVzdGVkRzRSU0E0MDk2U0hBMjU2VGltZVN0YW1waW5nQ0EuY3JsMIGQBggr
# BgEFBQcBAQSBgzCBgDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQu
# Y29tMFgGCCsGAQUFBzAChkxodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGln
# aUNlcnRUcnVzdGVkRzRSU0E0MDk2U0hBMjU2VGltZVN0YW1waW5nQ0EuY3J0MA0G
# CSqGSIb3DQEBCwUAA4ICAQBVqioa80bzeFc3MPx140/WhSPx/PmVOZsl5vdyipjD
# d9Rk/BX7NsJJUSx4iGNVCUY5APxp1MqbKfujP8DJAJsTHbCYidx48s18hc1Tna9i
# 4mFmoxQqRYdKmEIrUPwbtZ4IMAn65C3XCYl5+QnmiM59G7hqopvBU2AJ6KO4ndet
# Hxy47JhB8PYOgPvk/9+dEKfrALpfSo8aOlK06r8JSRU1NlmaD1TSsht/fl4JrXZU
# inRtytIFZyt26/+YsiaVOBmIRBTlClmia+ciPkQh0j8cwJvtfEiy2JIMkU88ZpSv
# XQJT657inuTTH4YBZJwAwuladHUNPeF5iL8cAZfJGSOA1zZaX5YWsWMMxkZAO85d
# NdRZPkOaGK7DycvD+5sTX2q1x+DzBcNZ3ydiK95ByVO5/zQQZ/YmMph7/lxClIGU
# gp2sCovGSxVK05iQRWAzgOAj3vgDpPZFR+XOuANCR+hBNnF3rf2i6Jd0Ti7aHh2M
# WsgemtXC8MYiqE+bvdgcmlHEL5r2X6cnl7qWLoVXwGDneFZ/au/ClZpLEQLIgpzJ
# GgV8unG1TnqZbPTontRamMifv427GFxD9dAq6OJi7ngE273R+1sKqHB+8JeEeOMI
# A11HLGOoJTiXAdI/Otrl5fbmm9x+LMz/F0xNAKLY1gEOuIvu5uByVYksJxlh9ncB
# jDGCBQAwggT8AgEBMCowFjEUMBIGA1UEAwwLSmltQnJpZ0RldnQCEG9HEsiy2yiS
# QUWBLSa68JswDQYJYIZIAWUDBAIBBQCggYQwGAYKKwYBBAGCNwIBDDEKMAigAoAA
# oQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4w
# DAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgfrqUZuyyWL8iFK15wjOfmp/a
# xcqZJ0IUD8z4U7eR18AwDQYJKoZIhvcNAQEBBQAEggEAiPTCWMC90mtEPP/Tj2dr
# 0seWUCauOXIBEHZ8TIETVJo+u3FOL1aV6jEhNXL6MSXwpkQWEpx4eUz0G75g0EZn
# 2JotgbvonlByDn7BmrZHLj9NXlpFYDu5eDzTLtFrveGt50Gx83fRuUfn6ar6outB
# GJuDYVh7tX9/wuDTAmjsphrhu3sCbrNcq/99ChH6+DScCyMqhE3EcCMUwCyJJnTr
# gJMfTpzeFhsed62EntUzprswNBSt6h0R1gV37VpMYwqaZ1DTIuMILHhqjly3JUOH
# A5l+QMoi4sC6fJ7UvJGBlkAStYWbTOaiC0NIWrr+YDIS2J2rA/IqU0WmIWL+7pmP
# 96GCAyAwggMcBgkqhkiG9w0BCQYxggMNMIIDCQIBATB3MGMxCzAJBgNVBAYTAlVT
# MRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE7MDkGA1UEAxMyRGlnaUNlcnQgVHJ1
# c3RlZCBHNCBSU0E0MDk2IFNIQTI1NiBUaW1lU3RhbXBpbmcgQ0ECEAxNaXJLlPo8
# Kko9KQeAPVowDQYJYIZIAWUDBAIBBQCgaTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
# AQcBMBwGCSqGSIb3DQEJBTEPFw0yMzAzMTMwMDI2NTJaMC8GCSqGSIb3DQEJBDEi
# BCBJL6MgKB5diU6FmXD6kZBaCAzexD2gJ2n1onTqB9NxjTANBgkqhkiG9w0BAQEF
# AASCAgC2dBamrkYOcq+ghGcRCuCWLdPYor3uO+8laYmk6kIw6znEuGhqnoW3iw0J
# Cqq4jT7LVrZA5vppWycjCRhe636MgL7Mv2YSOLjzQGdOc9ogbRh4TqeDTJWFOhaI
# OCUpv1I+YiIT1IEemb57yZKwzR9r2A7XYAARl4leefBbuZNvC6zdIwypL4tlBmkz
# KIWBv+FiPyMeH1vWMUepNJdmFdCkDgIfypJUomt1wgr+EXPzCdsnpZLYa9hGNoIy
# Nro+rnf7gUm65oDxhXgTcrAIdgSzcB1vF6piPf0HJfWAuL1vxDMRS1SA+lv2UWIB
# uWraEt3VY5sbQqf1F9728R3tEtZCBgWzDaMha9PxTmfoYMEKadvdLVwi0w9nft0w
# mYVEPodEw7M3tSEB2Zuk6Th0IXHAcgG6JND9e159WThcPdR0iSkgjWCCzNpITy4j
# diYFF2bUWwGw6+D0dYhyMSu/4SKJmAr70Pz+Z5loUmHr3EAOmaTdSJXUQBxjR0fO
# s+2elou8vR5TtjXCqSn/6VV6XKcASvnjeijhOszBKtgdxYj4Kk6RN8hvwpdHZyvQ
# FUOw2zS+BxO4uNUEaB8EavrwVhHz3UIxOHojdaV8PjCBwUkPl4ahL3S5NZfkNKh1
# HuvQUGThzcLOqWckaJUrwmq821tM4vmiB2E54fVthxly4Z9dzQ==
# SIG # End signature block
