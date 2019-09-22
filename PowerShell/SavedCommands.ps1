# File Description: This file contains several functions that can be used to save commands
#                   from one Powershell to the next. In this version, only the most recent
#                   command can be saved and commands are saved in the same directory as
#                   the $profile directory. The functions assume that directory already
#                   exists and may not function correctly if it does not exist.
# Recommended Usage: The recommended way to use these functions is to add them to the $profile
#                    file. This could be accomplished with the following command:
#
#                    Add-Content $profile (Get-Content <path to this file>)
#
#                    Using that approach will include these comments and the functions.
#                    Unless you want to always type the full name, I would also recommend setting
#                    aliases to the function names. I use nsc, gsc, esc, and rsc, which do
#                    not conflict with any of the standard aliases.

# Description: Saves the last command to the first available number in a file <number>.psc
# Arguments: None
# Results: A new file named <number>.psc, where number is the smallest available number,
#          will be created in the $profile directory with the last command as the content.
function NewSavedCommand() 
{
    $existing = Get-ChildItem (Split-Path $profile -parent) *.psc | 
                %{ [int]([System.IO.Path]::GetFileNameWithoutExtension($_.FullName)) }
    
    $i = 0;    
    while ($existing -contains $i)
    {
        $i += 1
    }
    
    Set-Content (Join-Path (Split-Path $profile -parent) ([string]$i + '.psc')) (Get-History -count 1).CommandLine
}

# Description: Gets the text of one or more saved commands.
# Arguments: commandNum - The number of command to be retreived
# Returns: If the number is negative, all saved commands will be listed
#          in a table with the number and command text. If the number is
#          not negative, the text for the corresponding command will be
#          printed. If there is no command for that number, a warning
#          will be printed.
function GetSavedCommand([int]$commandNum = -1)
{
    if ($commandNum -ge 0)
    {
        $cmdFile = (Join-Path (Split-Path $profile -parent) ([string]$commandNum + '.psc'))
        if (Test-Path $cmdFile)
        {
            Write-Output (gc $cmdFile)
        }
        else
        {
            Write-Warning 'There is no command with that number.'
        }
    }
    else
    {
        Get-ChildItem (Split-Path $profile -parent) *.psc | 
          Format-Table @{Label='Number'; Expression={[int]([System.IO.Path]::GetFileNameWithoutExtension($_.FullName))}},
                       @{Label='Command'; Expression={Get-Content $_.FullName}} -auto
    }
}

# Description: Executes a saved command.
# Arguments: commandNum - The non-negative number of the command to be retreived
# Results: Executes the saved command corresponding to the specified number
# Remarks: If the parameter does not reference an existing command, a message will be
#          printed.
function ExecuteSavedCommand([int]$commandNum = $(throw 'Must provide a non-negative command number.'))
{
    if ($commandNum -lt 0)
    {
        Write-Error 'The command number must be non-negative.'
    }
    else
    {
        $cmdFile = (Join-Path (Split-Path $profile -parent) ([string]$commandNum + '.psc'))
        if (test-path $cmdFile)
        {
            Get-Content $cmdFile | Invoke-Expression
        }
        else
        {
            Write-Warning 'There is no command with that number.'
        }
    }
}

# Description: Removes a saved command.
# Arguments: commandNum - The number of the command to be removed
# Results: Deletes the <commandNum>.psc file that contains the specified saved command.
# Remarks: Passing in a negative number will delete ALL saved commands. Use with caution.
function RemoveSavedCommand([int]$commandNum = $(throw 'Must provide a command number. (-1 deletes all saved commands)'))
{
    if ($commandNum -lt 0)
    {
        Remove-Item (Split-Path $profile -parent) *.psc
    }
    else
    {
        Remove-Item (Join-Path (Split-Path $profile -parent) ([string]$commandNum + '.psc'))
    }
}