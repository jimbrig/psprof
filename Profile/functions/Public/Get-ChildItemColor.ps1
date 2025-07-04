﻿Function Get-ChildItemColor {
    [CmdletBinding()]
    param (
        [String] $Directory = ".",
        $All = $false
    )
    $originalForeground = $host.ui.rawui.foregroundColor
    if ( $All ) {
        $toList = Get-ChildItem -force $Directory
    } else {
        $toList = Get-ChildItem $Directory
    }
    foreach ($Item in $toList) {
        Switch ($Item.Extension) {
            ".Exe" { $host.ui.rawui.foregroundColor = "Yellow" }
            ".cmd" { $host.ui.rawui.foregroundColor = "Red" }
            ".lnk" { $host.ui.rawui.foregroundColor = "Red" }
            ".msh" { $host.ui.rawui.foregroundColor = "Red" }
            ".vbs" { $host.ui.rawui.foregroundColor = "Red" }
            ".ps1" { $host.ui.rawui.foregroundColor = "Cyan" }
            ".psm1" { $host.ui.rawui.foregroundColor = "Cyan" }
            ".psd1" { $host.ui.rawui.foregroundColor = "Cyan" }
            ".ps1xml" { $host.ui.rawui.foregroundColor = "Cyan" }
            ".txt" { $host.ui.rawui.foregroundColor = "DarkCyan" }
            ".xml" { $host.ui.rawui.foregroundColor = "Magenta" }
            ".cvs" { $host.ui.rawui.foregroundColor = "Magenta" }
            ".doc" { $host.ui.rawui.foregroundColor = "Magenta" }
            ".csv" { $host.ui.rawui.foregroundColor = "Magenta" }
            ".bat" { $host.ui.rawui.foregroundColor = "Yellow" }
            ".docx" { $host.ui.rawui.foregroundColor = "Magenta" }
            ".pdf" { $host.ui.rawui.foregroundColor = "Magenta" }
            ".xls" { $host.ui.rawui.foregroundColor = "Magenta" }
            ".xlsx" { $host.ui.rawui.foregroundColor = "Magenta" }
            ".log" { $host.ui.rawui.foregroundColor = "DarkCyan" }
            Default { $host.ui.rawui.foregroundColor = $originalForeground }
        }
        if ($item.Mode.StartsWith("d")) { $host.ui.rawui.foregroundColor = "Green" }
        $item
    }
    $host.ui.rawui.foregroundColor = $originalForeground
}
#EndRegion LL
