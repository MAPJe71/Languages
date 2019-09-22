function prompt
{
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal] $identity

    $(if (Test-Path variable:/PSDebugContext)
        { '[DBG]: ' }

    elseif($principal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
        { "[ADMIN]: " }

    else { '' }) + 'PS ' + $(Get-Location) + $(if ($nestedpromptlevel -ge 1) { '>>' }) + '> '
}

function Get-Batchfile ($file) {
    $cmd = "`"$file`" & set"
    # Execute console command and clone all environment variables
    cmd /c $cmd | Foreach-Object {
        $p, $v = $_.split('=')
        Set-Item -path env:$p -value $v
    }
}

function VsVars32($version = "10.0")
{
    $key = "HKLM:SOFTWARE\Microsoft\VisualStudio\" + $version
    if ([intptr]::size -eq 8)
    {
        $key = "HKLM:SOFTWARE\Wow6432Node\Microsoft\VisualStudio\" + $version
    }
    if (Test-Path -path $key)
    {
        $VsKey = Get-ItemProperty $key
        if ($VsKey)
        {
            $VsInstallPath = [System.IO.Path]::GetDirectoryName($VsKey.InstallDir)
            $VsToolsDir = [System.IO.Path]::GetDirectoryName($VsInstallPath)
            $VsToolsDir = [System.IO.Path]::Combine($VsToolsDir, "Tools")
            $BatchFile = [System.IO.Path]::Combine($VsToolsDir, "vsvars32.bat")
            Get-Batchfile $BatchFile
        }

        $vsVersion = @{ 12.0="2013"; "12.0"="2013"; 
                        11.0="2012"; "11.0"="2012"; 
                        10.0="2010"; "10.0"="2010"; 
                         9.0="2008";  "9.0"="2008";  
                         8.0="2005";  "8.0"="2005";  
                         7.1="2003";  "7.1"="2003";
                         7.0="2002";  "7.0"="2002";  
                         6.0=   "6";  "6.0"=   "6"; }
                         
        [System.Console]::Title = "Visual Studio " + $version + "/" + $vsVersion[$version] + " Windows Powershell"
        
        $iconPath = $env:ToolboxDrive + "\myBriefcase\Graphics\Console\powershell-vs" + $vsVersion[$version] + ".ico"
        if(Test-Path -path $iconPath)
        {
            Set-ConsoleIcon $iconPath
        }
    }
}

Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# DotSource the Console Icon Stuff
. .\Set-ConsoleIcon.ps1

Pop-Location
