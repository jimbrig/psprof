﻿Funciton Optimize-DefenderExclusions {
    [CmdletBinding(ConfirmImpact = 'Medium', SupportsShouldProcess)]
    param ()

    begin {
        #region DefaultExclusions
        $ExcludePathList = @(
            "$env:windir\SoftwareDistribution\DataStore\Datastore.edb",
            "$env:windir\SoftwareDistribution\DataStore\Logs\Edb*.jrs",
            "$env:windir\SoftwareDistribution\DataStore\Logs\Edb.chk",
            "$env:windir\SoftwareDistribution\DataStore\Logs\Tmp.edb",
            "$env:windir\Security\Database\*.edb",
            "$env:windir\Security\Database\*.sdb",
            "$env:windir\Security\Database\*.log",
            "$env:windir\Security\Database\*.chk",
            "$env:windir\Security\Database\*.jrs",
            "$env:windir\Security\Database\*.xml",
            "$env:windir\Security\Database\*.csv",
            "$env:windir\Security\Database\*.cmtx",
            "$env:ProgramData\ntuser.pol",
            "$env:windir\System32\GroupPolicy\Machine\Registry.pol",
            "$env:windir\System32\GroupPolicy\Machine\Registry.tmp",
            "$env:windir\System32\GroupPolicy\User\Registry.pol",
            "$env:windir\System32\GroupPolicy\User\Registry.tmp"
        )
        #endregion DefaultExclusions

        #region AdExclusions
        # Turn off scanning of Active Directory and Active Directory-related files

        # Exclude the Main NTDS database files.
        $DSADatabaseFile = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NTDS\Parameters'
        $DSADatabaseFilePath = ('Registry::' + $DSADatabaseFile)
        if (Test-Path -Path $DSADatabaseFilePath) {
            $DSADatabaseFileValue = (Get-ItemProperty -Path $DSADatabaseFilePath | Select-Object -ExpandProperty 'DSA Database file' -ErrorAction SilentlyContinue)
            if ($DSADatabaseFileValue) {
                $ExcludePathList += ($DSADatabaseFileValue)
                $ExcludePathList += ($DSADatabaseFileValue).Replace('.dit', '.pat')
            }
        } else {
            Write-Verbose -Message 'No NTDS database files to exclude'
        }

        # Exclude the Active Directory transaction log files.
        $DatabaseLogFiles = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NTDS\Parameters'
        $DatabaseLogFilesPath = ('Registry::' + $DatabaseLogFiles)
        if (Test-Path -Path $DatabaseLogFilesPath) {
            $DatabaseLogFilesPathValue = (Get-ItemProperty -Path $DatabaseLogFilesPath | Select-Object -ExpandProperty 'Database Log Files Path' -ErrorAction SilentlyContinue)
            if ($DatabaseLogFilesPathValue) {
                $ExcludePathList += ($DatabaseLogFilesPathValue + '\EDB*.log')
                $ExcludePathList += ($DatabaseLogFilesPathValue + '\Res*.log')
                $ExcludePathList += ($DatabaseLogFilesPathValue + '\Edb*.jrs')
                $ExcludePathList += ($DatabaseLogFilesPathValue + '\Ntds.pat')
            }
        } else {
            Write-Verbose -Message 'No Active Directory transaction log files to exclude'
        }

        # Exclude the files in the NTDS Working folder
        $DSAWorkingDir = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NTDS\Parameters'
        $DSAWorkingDirPath = ('Registry::' + $DSAWorkingDir)
        if (Test-Path -Path $DSAWorkingDirPath) {
            $DSAWorkingDirValue = (Get-ItemProperty -Path $DSAWorkingDirPath | Select-Object -ExpandProperty 'DSA Working Directory' -ErrorAction SilentlyContinue)
            if ($DSAWorkingDirValue) {
                $ExcludePathList += ($DSAWorkingDirValue + '\Temp.edb')
                $ExcludePathList += ($DSAWorkingDirValue + '\Edb.chk')
            }
        } else {
            Write-Verbose -Message 'No NTDS Working folder to exclude'
        }
        #endregion AdExclusions

        #region SysVolExclusions
        # Turn off scanning of SYSVOL files

        # Turn off scanning of files in the File Replication Service (FRS) Working folder
        $SysVolWorkingDir = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NtFrs\Parameters'
        $SysVolWorkingDirPath = ('Registry::' + $SysVolWorkingDir)
        if (Test-Path -Path $SysVolWorkingDirPath) {
            $SysVolWorkingDirValue = (Get-ItemProperty -Path $SysVolWorkingDirPath | Select-Object -ExpandProperty 'Working Directory' -ErrorAction SilentlyContinue)
            if ($SysVolWorkingDirValue) {
                $ExcludePathList += ($SysVolWorkingDirValue + '\jet\sys\edb.chk')
                $ExcludePathList += ($SysVolWorkingDirValue + '\jet\Ntfrs.jdb')
                $ExcludePathList += ($SysVolWorkingDirValue + '\jet\log\*.log')
            }
        } else {
            Write-Verbose -Message 'No File Replication Service Working folder to exclude'
        }

        # Turn off scanning of files in the File Replication Service Database Log files
        $SysVolDBLogFileDir = 'HKEY_LOCAL_MACHINE\SYSTEM\Currentcontrolset\Services\Ntfrs\Parameters'
        $SysVolDBLogFileDirPath = ('Registry::' + $SysVolDBLogFileDir)
        if (Test-Path -Path $SysVolDBLogFileDirPath) {
            $SysVolDBLogFileDirValue = (Get-ItemProperty -Path $SysVolWorkingDirPath | Select-Object -ExpandProperty 'Working Directory' -ErrorAction SilentlyContinue)
            if ($SysVolDBLogFileDirValue) {
                $ExcludePathList += ($SysVolDBLogFileDirValue + '\Jet\Log\Edb*.jrs')
            } else {
                if ($SysVolWorkingDirValue) {
                    $ExcludePathList += ($SysVolWorkingDirValue + '\jet\Log\Edb*.log')
                }
            }
        } else {
            Write-Verbose -Message 'No File Replication Service Database Log files to exclude'
        }
        #endregion SysVolExclusions

        #region DhcpExclusions
        # Turn off scanning of DHCP files
        $DhcpFiles = 'HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\DHCPServer\Parameters'
        $DhcpFilesPath = ('Registry::' + $DhcpFiles)
        if (Test-Path -Path $DhcpFilesPath) {
            $DhcpDatabasePathValue = (Get-ItemProperty -Path $DhcpFilesPath | Select-Object -ExpandProperty 'DatabasePath' -ErrorAction SilentlyContinue)
            if ($DhcpDatabasePathValue) {
                $ExcludePathList += ($DhcpDatabasePathValue + '\*.mdb')
                $ExcludePathList += ($DhcpDatabasePathValue + '\*.pat')
                $ExcludePathList += ($DhcpDatabasePathValue + '\*.chk')
                $ExcludePathList += ($DhcpDatabasePathValue + '\*.edb')
            }

            $DhcpLogFilePathValue = (Get-ItemProperty -Path $DhcpFilesPath | Select-Object -ExpandProperty 'DhcpLogFilePath' -ErrorAction SilentlyContinue)
            if (($DhcpLogFilePathValue) -and ($DhcpLogFilePathValue -ne $DhcpDatabasePathValue)) {
                $ExcludePathList += ($DhcpLogFilePathValue + '\*.log')
            } else {
                $ExcludePathList += ($DhcpDatabasePathValue + '\*.log')
            }

            $DhcpBackupDatabasePathValue = (Get-ItemProperty -Path $DhcpFilesPath | Select-Object -ExpandProperty 'BackupDatabasePath' -ErrorAction SilentlyContinue)
            if ($DhcpBackupDatabasePathValue) {
                $ExcludePathList += ($DhcpBackupDatabasePathValue + '\new\*.mdb')
                $ExcludePathList += ($DhcpBackupDatabasePathValue + '\new\*.pat')
                $ExcludePathList += ($DhcpBackupDatabasePathValue + '\new\*.chk')
                $ExcludePathList += ($DhcpBackupDatabasePathValue + '\new\*.edb')
                $ExcludePathList += ($DhcpBackupDatabasePathValue + '\new\*.log')
            }
        } else {
            Write-Verbose -Message 'No DHCP Server Directory found'
        }
        #endregion DhcpExclusions

        #region DnsExclusions
        $DnsServerDir = "$env:windir\System32\dns"
        if (Test-Path -Path $DnsServerDir -ErrorAction SilentlyContinue) {
            $ExcludePathList += ($DnsServerDir + '\*.log')
            $ExcludePathList += ($DnsServerDir + '\*.dns')
            $ExcludePathList += ($DnsServerDir + '\BOOT')

            $DnsBackupServerDir = ($DnsServerDir + '\backup')
            if (Test-Path -Path $DnsBackupServerDir -ErrorAction SilentlyContinue) {
                $ExcludePathList += ($DnsBackupServerDir + '\*.log')
                $ExcludePathList += ($DnsBackupServerDir + '\*.dns')
                $ExcludePathList += ($DnsBackupServerDir + '\BOOT')
            }
        } else {
            Write-Verbose -Message 'No DNS Server Directory found'
        }
        #endregion DnsExclusions

        #region WinsExclusions
        $WinsServerDir = "$env:windir\System32\Wins"
        if (Test-Path -Path $WinsServerDir -ErrorAction SilentlyContinue) {
            Write-Warning -Message 'WINS is still installed on this system!' -WarningAction Continue

            $ExcludePathList += ($WinsServerDir + '\*.chk')
            $ExcludePathList += ($WinsServerDir + '\*.log')
            $ExcludePathList += ($WinsServerDir + '\*.mdb')
        } else {
            Write-Verbose -Message 'No WINS Server Directory found'
        }
        #endregion WinsExclusions
    }

    process {
        if ($pscmdlet.ShouldProcess($ExcludePathList, 'Exclude from Microsoft Defender Scanning')) {
            # Loop over the list we created
            foreach ($ExcludePath in $ExcludePathList) {
                try {
                    # Splat the parameters for Add-MpPreference
                    $SplatAddMpPreference = @{
                        ExclusionPath = $ExcludePath
                        Force         = $true
                        ErrorAction   = 'Stop'
                        WarningAction = 'Continue'
                    }
                    $null = (Add-MpPreference @SplatAddMpPreference)
                } catch {
                    #region ErrorHandler
                    # get error record
                    [Management.Automation.ErrorRecord]$e = $_

                    # retrieve information about runtime error
                    $info = @{
                        Exception = $e.Exception.Message
                        Reason    = $e.CategoryInfo.Reason
                        Target    = $e.CategoryInfo.TargetName
                        Script    = $e.InvocationInfo.ScriptName
                        Line      = $e.InvocationInfo.ScriptLineNumber
                        Column    = $e.InvocationInfo.OffsetInLine
                    }

                    # Error Stack
                    $info | Out-String | Write-Verbose

                    # Just display the info on continue with the rest of the list
                    Write-Warning -Message ($info.Exception) -ErrorAction Continue -WarningAction Continue

                    # Cleanup
                    $info = $null
                    $e = $null
                    #endregion ErrorHandler
                }
            }
        }
    }
}
