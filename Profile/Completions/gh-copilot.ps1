function ghcs {
	# Debug support provided by common PowerShell function parameters, which is natively aliased as -d or -db
	# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_commonparameters?view=powershell-7.4#-debug
	param(
		[Parameter()]
		[string]$Hostname,

		[ValidateSet('gh', 'git', 'shell')]
		[Alias('t')]
		[String]$Target = 'shell',

		[Parameter(Position=0, ValueFromRemainingArguments)]
		[string]$Prompt
	)
	begin {
		# Create temporary file to store potential command user wants to execute when exiting
		$executeCommandFile = New-TemporaryFile

		# Store original value of GH_* environment variable
		$envGhDebug = $Env:GH_DEBUG
		$envGhHost = $Env:GH_HOST
	}
	process {
		if ($PSBoundParameters['Debug']) {
			$Env:GH_DEBUG = 'api'
		}

		$Env:GH_HOST = $Hostname

		gh copilot suggest -t $Target -s "$executeCommandFile" $Prompt
	}
	end {
		# Execute command contained within temporary file if it is not empty
		if ($executeCommandFile.Length -gt 0) {
			# Extract command to execute from temporary file
			$executeCommand = (Get-Content -Path $executeCommandFile -Raw).Trim()

			# Insert command into PowerShell up/down arrow key history
			[Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($executeCommand)

			# Insert command into PowerShell history
			$now = Get-Date
			$executeCommandHistoryItem = [PSCustomObject]@{
				CommandLine = $executeCommand
				ExecutionStatus = [Management.Automation.Runspaces.PipelineState]::NotStarted
				StartExecutionTime = $now
				EndExecutionTime = $now.AddSeconds(1)
			}
			Add-History -InputObject $executeCommandHistoryItem

			# Execute command
			Write-Host "`n"
			Invoke-Expression $executeCommand
		}
	}
	clean {
		# Clean up temporary file used to store potential command user wants to execute when exiting
		Remove-Item -Path $executeCommandFile

		# Restore GH_* environment variables to their original value
		$Env:GH_DEBUG = $envGhDebug
	}
}

function ghce {
	# Debug support provided by common PowerShell function parameters, which is natively aliased as -d or -db
	# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_commonparameters?view=powershell-7.4#-debug
	param(
		[Parameter()]
		[string]$Hostname,

		[Parameter(Position=0, ValueFromRemainingArguments)]
		[string[]]$Prompt
	)
	begin {
		# Store original value of GH_* environment variables
		$envGhDebug = $Env:GH_DEBUG
		$envGhHost = $Env:GH_HOST
	}
	process {
		if ($PSBoundParameters['Debug']) {
			$Env:GH_DEBUG = 'api'
		}

		$Env:GH_HOST = $Hostname

		gh copilot explain $Prompt
	}
	clean {
		# Restore GH_* environment variables to their original value
		$Env:GH_DEBUG = $envGhDebug
		$Env:GH_HOST = $envGhHost
	}
}
