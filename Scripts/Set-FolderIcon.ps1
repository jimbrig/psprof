
<#PSScriptInfo

.VERSION 1.0.2

.GUID b4bc8c7c-92fc-46cb-9f61-3e2118597165

.AUTHOR Jimmy Briggs

.COMPANYNAME jimbrig

.COPYRIGHT Jimmy Briggs | 2023

.TAGS Windows Utility Directories Configure Personalization Tool

.LICENSEURI https://github.com/jimbrig/PSScripts/blob/main/LICENSE

.PROJECTURI https://github.com/jimbrig/PSScripts/Set-FolderIcon/

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
    **Version 1.0.2**

    - Added Script Certificate Signature

    **Version 1.0.1**

    - Added a check to see if the desktop.ini file already exists in the target directory. 
        If it does, it will throw a warning and not overwrite the file.

    - Added LICENSEURI, PROJECTURI, and RELEASENOTES to the PSScriptInfo block.

.PRIVATEDATA

#>

<# 

.SYNOPSIS
    This function sets a folder icon on specified folder.
.DESCRIPTION 
    A Script to set the icon for a provided folder. 
    Will create two files in the destination path, both set as hidden system files: DESKTOP.ini and FOLDER.ICO. 
.PARAMETER Icon
    Path to the icon (*.ico) file to use.
.PARAMETER Path
    Path to the folder to add the icon to.
.PARAMETER Recurse
    [Boolean] Recurse sub-directories?
.EXAMPLE
    Set-FolderIcon -Icon "C:\Users\Mark\Downloads\Radvisual-Holographic-Folder.ico" -Path "C:\Users\Mark"
    
    # Changes the default folder icon to the custom one I donwloaded from Google Images.
.EXAMPLE
    Set-FolderIcon -Icon "C:\Users\Mark\Downloads\wii_folder.ico" -Path "\\FAMILY\Media\Wii"
    
    # Changes the default folder icon to custom one for a UNC Path.
.EXAMPLE
    Set-FolderIcon -Icon "C:\Users\Mark\Downloads\Radvisual-Holographic-Folder.ico" -Path "C:\Test" -Recurse
    
    # Changes the default folder icon to custom one for all folders in specified folder and that folder itself.
#> 
[CmdletBinding()]
Param(
    [Parameter(Mandatory = $True, Position = 0)]
    [string[]]$Icon,
    [Parameter(Mandatory = $True, Position = 1)]
    [string]$Path
)

If (!(Test-Path $Icon)) {
    throw "[Error] Specified Icon Path not found: $Icon"
}

If (!(Test-Path $Path)) {
    throw "[Error] Specified Directory Path not found: $Path"
}

$TargetDirectory = Convert-Path $Path

$DesktopIni = "[.ShellClassInfo]`n" + "IconResource=$Icon`n"

If (Test-Path "$($TargetDirectory)\desktop.ini") {
    Write-Warning -Message 'desktop.ini already found within directory.'
}
	
Add-Content "$($TargetDirectory)\desktop.ini" -Value $DesktopIni
	(Get-Item "$($TargetDirectory)\desktop.ini" -Force).Attributes = 'Hidden, System, Archive'
	(Get-Item $TargetDirectory -Force).Attributes = 'ReadOnly, Directory'


# SIG # Begin signature block
# MIIbsQYJKoZIhvcNAQcCoIIbojCCG54CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCA7tJMcfgJvzqiq
# 5dTPrwFtb0qBa4ZlCbqVzjoefuP3+aCCFgcwggL8MIIB5KADAgECAhB+/UWa6VZ/
# pk89wo9qoFZLMA0GCSqGSIb3DQEBCwUAMBYxFDASBgNVBAMMC0ppbUJyaWdEZXZ0
# MB4XDTIzMDIxNjIyNTIxN1oXDTI0MDIxNjIzMTIxN1owFjEUMBIGA1UEAwwLSmlt
# QnJpZ0RldnQwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCf1gVGlos2
# GxLlp+iZAPw+0G12nbNv9VAXYILhQmX2fblgxtUhyWJNFaoufdunBI9ismhWgt32
# mEuDQPkzGdu99QOLZow/XoDmAzMy5g72e54hgqC4nsI3QBDyX1QO39GvZnkpo8EN
# K7XzsFDS1j60gG2kNg5+G4qvRTHwwf6aJBAPANcH3Jv/chejBjIMn9jRiGsSvPcL
# UyUh5sYxrEyYgALvF/KIpgXciM86D0OK3rjq+BrMr6Ay4TUWVWnCsHL/dSaToruM
# dt90Zne/7ynyAAXWDr9js6Q9w2FY0vL40y1XdzH4ooEch/MUiOxIyMu2G8/v40dV
# LKYN7ievRH7tAgMBAAGjRjBEMA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggr
# BgEFBQcDAzAdBgNVHQ4EFgQUcLKD0tWLAGtTz0VLlh2PT8+JW3IwDQYJKoZIhvcN
# AQELBQADggEBAFlmryraqlsSKZ+QMrmoFXBECTjTEMPuGj+4DAjA/3zV9tMJxhDI
# YySYVka9IBR8VoBHti7N3GMAvD9tQCt6u9rjpbXM9V3VmEBPJSVqb7xe8hnx9ZP4
# mxfQ2vEK+Ip7MnQLPayQY2kySlhHskQ0thIGhDfPChSMOM1yi5QIVyO4Fmgsfn6i
# ovtxxKMlFwzImusk9L5zJHP4p/6RONK0HRNvWmoY5lrtxdZHYNPqpfe6LAX9PTUp
# U59hFKfh9pE3HwxuHCwVUXrcf091ei4KuwTmcsLYPoCubZW6VN72Ucnh4KGGFStN
# FCa8oqRwnWcFQET79D0cBYLDsMhrH5/41HkwggWNMIIEdaADAgECAhAOmxiO+dAt
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
# jDGCBQAwggT8AgEBMCowFjEUMBIGA1UEAwwLSmltQnJpZ0RldnQCEH79RZrpVn+m
# Tz3Cj2qgVkswDQYJYIZIAWUDBAIBBQCggYQwGAYKKwYBBAGCNwIBDDEKMAigAoAA
# oQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4w
# DAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgf04oCiKwGz/30lyRPAVQKd5b
# +AHVh4yLZlvixnoC6LMwDQYJKoZIhvcNAQEBBQAEggEAD5Nb+nb/iu6K5gwnmF//
# Ff9d9TI8ak/6NNwMr6H6kfgfImutfZEyN2ZycodvEqvYBV4uF5eLEtkbn0/LHL2p
# KL0UnrHwxcF9xpMXBKrRMF+e5Lg1Xnq4f5vv279JWDq5VcBiJ0TZf7Kly22HIIte
# jwlLBiEYTUjMbeSQmWpkK+96wKvgdBLUt2CBh/+1n0sj1PtC8ZxIvd3fYP3wMHiC
# 8mFo1Xhp76t8L7OrXaO9vflEV/4dz0AEx18hkpZJHaa+qp/iYSy0xEaae9EC7Pzr
# 8z3pKhNg1xWbudT3X2TGqOiPomhRm8Js8ZD5yANQbhQ77rfuJW+Wfv5dn2D9wxrX
# /qGCAyAwggMcBgkqhkiG9w0BCQYxggMNMIIDCQIBATB3MGMxCzAJBgNVBAYTAlVT
# MRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE7MDkGA1UEAxMyRGlnaUNlcnQgVHJ1
# c3RlZCBHNCBSU0E0MDk2IFNIQTI1NiBUaW1lU3RhbXBpbmcgQ0ECEAxNaXJLlPo8
# Kko9KQeAPVowDQYJYIZIAWUDBAIBBQCgaTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
# AQcBMBwGCSqGSIb3DQEJBTEPFw0yMzAyMTYyMzQ0MDZaMC8GCSqGSIb3DQEJBDEi
# BCBFgrtUD/GwJuB2szbt1awzMc4pQCrxZH2suaKI0/+7eDANBgkqhkiG9w0BAQEF
# AASCAgDOGQEAGVM3MAmpDgC7DfMIORn7SayRNgha303A+jZNMAjdRxIXTpEgyB1y
# Juy1BjcSBUjuNk99sm3I29Kbk4EFoB1HaOJ7qmk3ZKuqyCzTCwzJkBEB0X9HkcmK
# h2qJ2IkG1QKwdqQ+9EmcjbcaCglbcaG5l8DT/ppFPzZhLZSYUphR/X60i8aatG5W
# 4N8frCZTAMLZdDlOuWecsNdAfqfEInhdjkVyc/bPbCGUdJYAkPIzygdVIEkIuC5D
# HV4F2uVB6tHN2rg4rMex4NSZnbsN5Egieoifo3cQuQt6l2Oale8P14/+47jXn+LW
# Rw2p0tFdU6tKBtiGLEvfrHiEAIdLNYedmEA8mpRo5QxddWmbMzYm2PfNjLrglZPy
# G9Z+CTnL0PWE1TuODyINy5S1v9MpLgxAcCJoZNd2wDNW4o1XbK4E+12Aa4JTij31
# j4lBq+M6mELQon7/ioKm9D60N4DWwX51ztEyjCuHLZZS4UwGHtypbWmQ+CDVSyaW
# ki7ipVx9CSLIlZhmxDN1hl96RA/LxYmV67wguvyEARe5HFQ+uejbMfAl4NqDtmvp
# B7uVJP0zJNMLhk8CbdC5gd+NUBoS97LvHljTU6EGYxgySYzVp3TjGaLcHhsiGs9A
# 324Wl6MhosiDqf4zqEOf6jA0L4Lop4rdFXlz4Lm+vWf0J3A/mw==
# SIG # End signature block
