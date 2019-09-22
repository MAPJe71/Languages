# $Date: 2009-10-04 08:48:59 +0200 (So, 04 Okt 2009) $
# $Rev: 1 $
# $Author: fpschultze $
# $URL: http://fpschultze.unfuddle.com/svn/fpschultze_ps-ini-file-functions/IniFileFunctions.ps1 $

Function Import-Ini (
	[string]$Path = $(Read-Host "Please supply a value for the Path parameter")
)
{
	$ini = @{}
	if (Test-Path -Path $Path)
	{
		switch -regex -file $Path
		{
			"^\[(.+)\]$"
			{
				$Category = $matches[1]
				$ini.$Category = @{}
			}
			"(.+)=(.+)"
			{
				$Key,$Value = $matches[1..2]
				$ini.$Category.$Key = $Value
			}
		}
	}
	else
	{
		Write-Host "File not found - $Path"
	}
	$ini
}

Function Export-Ini (
	[hashtable]$inputObject = $(Read-Host "Supply a value for the inputObject parameter"),
	[string]$Path = $(Read-Host "Supply a value for the Path parameter")
)
{
	$Content = @()
	ForEach ($Category in $inputObject.Keys)
	{
		$Content += "[$Category]"
		ForEach ($Key in $inputObject.$Category.Keys)
		{
			$Content += "$Key=$($inputObject.$Category.$Key)"
		}
	}
	$Content | Set-Content $Path -Force
}

Function Remove-IniCategory (
	[string]$Path = $(Read-Host -Prompt "Supply a value for the Path parameter"),
	[string]$Category = $(Read-Host -Prompt "Supply a value for the Category parameter")
)
{
	$ini = Import-Ini -Path $Path
	if ($ini.Count)
	{
		if ($ini.Contains($Category))
		{
			$ini.Remove($Category)
			Export-Ini -inputObject $ini -Path $Path
		}
		else
		{
			Write-Host "Category $Category does not exist in $Path"
		}
	}
}

Function Remove-IniKey (
	[string]$Path = $(Read-Host -Prompt "Supply a value for the Path parameter"),
	[string]$Category = $(Read-Host -Prompt "Supply a value for the Category parameter"),
	[string]$Key = $(Read-Host -Prompt "Supply a value for the Key parameter")
)
{
	$ini = Import-Ini -Path $Path
	if ($ini.Count)
	{
		if ($ini.Contains($Category))
		{
			if ($ini.$Category.Contains($Key))
			{
				$ini.$Category.Remove($Key)
				Export-Ini -inputObject $ini -Path $Path
			}
			else
			{
				Write-Host "Key $Key does not exist in $Path, category $Category"
			}
		}
		else
		{
			Write-Host "Category $Category does not exist in $Path"
		}
	}
}

Function Get-IniKey (
	[string]$Path = $(Read-Host -Prompt "Supply a value for the Path parameter"),
	[string]$Category = $(Read-Host -Prompt "Supply a value for the Category parameter"),
	[string]$Key = $(Read-Host -Prompt "Supply a value for the Key parameter")
)
{
	$ini = Import-Ini -Path $Path
	if ($ini.Count)
	{
		if ($ini.Contains($Category))
		{
			if ($ini.$Category.Contains($Key))
			{
				$ini.$Category.$Key
			}
			else
			{
				Write-Host "Key $Key does not exist in $Path, category $Category"
			}
		}
		else
		{
			Write-Host "Category $Category does not exist in $Path"
		}
	}
}

Function Set-IniKey (
	[string]$Path = $(Read-Host -Prompt "Supply a value for the Path parameter"),
	[string]$Category = $(Read-Host -Prompt "Supply a value for the Category parameter"),
	[string]$Key = $(Read-Host -Prompt "Supply a value for the Key parameter"),
	[string]$Value = $(Read-Host -Prompt "Supply a value for the Value parameter"),
	[switch]$Force
)
{
	$ini = Import-Ini -Path $Path
	if ($ini.Count)
	{
		if (!($ini.Contains($Category)))
		{
			if ($Force)
			{
				$ini.$Category = @{}
			}
			else
			{
				Write-Host "Category $Category does not exist in $Path"
				return
			}
		}
		if ($ini.$Category.Contains($Key))
		{
			if (!$Force)
			{
				Write-Host "Key $Key already exists in $Path, category $Category"
				return
			}
		}
		$ini.$Category.$Key = $Value
		Export-Ini -inputObject $ini -Path $Path
	}
}