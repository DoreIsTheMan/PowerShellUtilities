<#
.SYNOPSIS
    Allows a user to choose yes or no.
.DESCRIPTION
    Allows a user to choose yes or no based on a given prompt, or a default prompt if no message is provided.
.PARAMETER Message
    Provides the message to be displayed before prompting the user to choose yes or no.
.NOTES
    This function presents the user with an answerable yes/no prompt.
    Once the user has provided their answer, the function will return the boolean equivalent of that answer.
    If the answer doesn't match the criteria, it will return nothing.
.EXAMPLE
    Select-YesOrNo "Do you like soup?"
    Presents the user with the prompt "Do you like soup?" and passes the boolean value back to the caller.
#>
function Select-YesOrNo{
	[CmdletBinding()]
	param(
		[string]$Message
	)
	$selection = if($message){ Read-Host $message }else{ Read-Host "Would you like to do the thing? (y/n)" }
	Switch ($selection)
	{
		Y { $chosen = $true }
		Yes {$chosen = $true }
		N { $chosen = $false }
		No { $chosen = $false }
	}
	return $chosen
}

<#
.SYNOPSIS
    Displays a popup to the user.
.DESCRIPTION
    Displays a popup to the user, containing a message, window title, an "OK" button, and an optional "Cancel" button.
.OUTPUTS
    Returns 1 when the user selects the "OK" button.
    Returns 2 when the user selects the "Cancel" button.
    Both return values are of type Int32.
.EXAMPLE
    Show-Popup "Something happened!" "Generic Error"
    Displays a popup to the user with the message "Something happened!" and window title "Generic Error".
    This example would display an "OK" button, but no "Cancel" button.
.EXAMPLE
    Show-Popup "Something happened!" "Generic Error" -CancelButton
    Displays a popup to the user with the message "Something happened!" and window title "Generic Error".
    This example would display an "OK" button and a "Cancel" button.
#>
function Show-Popup{
	[CmdletBinding()]
	Param(
	[Parameter(Mandatory=$true)]
	$message,
	[Parameter(Mandatory=$true)]
	$windowTitle,
	[Parameter()]
	[switch]$CancelButton
	)
	$result = $null;
	if($CancelButton){
		$result = (new-object -ComObject wscript.shell).Popup($message,0,$windowTitle,0x1)
	}
	else{
		$result = (new-object -ComObject wscript.shell).Popup($message,0,$windowTitle)
	}
	return $result;
}

<#
.SYNOPSIS
    Returns the current date according to the ISO 8601 international standard.
.DESCRIPTION
    Returns the current date according to the ISO 8601 international standard.
    The default format used is the basic format, without delimiters.
.PARAMETER Extended
    Determines whether to use the extended format, which includes delimiters.
.NOTES
    I built this primarily for quick file name timestamps, so the Basic format was chosen to be the default.
.EXAMPLE
    Get-DateTime
    Returns the current datetime value using "yyyyMMddTHHmmss" as the format parameter.
.EXAMPLE
    Get-DateTime -Extended
    Returns the current datetime value using "yyyy-MM-ddTHH:mm:ss" as the format parameter.
#>
function Get-DateTime{
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        $Extended
    )
    $format = if(-not $Extended){"yyyyMMddTHHmmss"}else{"yyyy-MM-ddTHH:mm:ss"}
	return Get-Date -Format $format
}

##### ALIASES #####
New-Alias -Name 'Choose' -Value 'Select-YesOrNo' -Force
New-Alias -Name 'Popup' -Value 'Show-Popup' -Force
New-Alias -Name 'Date' -Value 'Get-DateTime' -Force

##### SPECIAL UTILITY #####
<#
.SYNOPSIS
    Loads a new PowerShell session in the current window.
.DESCRIPTION
    Loads a new PowerShell session in the current window. 
    This is useful when you want to clear session variables, after rebuilding modules, or to simply create a clean session.
.NOTES
    This is my most used command - I promise that if you do any amount of PowerShell development, you will be using this all the time.
    I commonly use the 'Reload' alias, and will pair that with a 'cls' command to make the window appear as a fresh PowerShell window.
    This command is the main reason I ever built this module, but the other commands are nice additions for daily PowerShell development.
.EXAMPLE
    Restart-PowerShell
    Loads a new PowerShell session in the current window.
.EXAMPLE
    Reload
    Loads a new PowerShell session in the current window by using the 'Reload' alias
.EXAMPLE
    $>cls
    >>reload
    Clears the PowerShell window, then loads a new PowerShell session in the current window.
#>
function Restart-PowerShell {
    if ($host.Name -eq 'ConsoleHost') {
		powershell
		exit
	}
}
New-Alias -Name 'Reload' -Value 'Restart-PowerShell' -Force

##### EXPORT MODULE MEMBERS #####
Export-ModuleMember -Function * -Alias *