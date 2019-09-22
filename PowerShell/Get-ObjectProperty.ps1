Function Get-ObjectProperty
{
  param
  (
    $Name = '*',
    $Value = '*',
    $Type = '*',
    [Switch]$IsNumeric,
 
    [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [Object[]]$InputObject,
 
    $Depth = 4,
    $Prefix = '$obj'
  )
 
  Begin
  {
    $x = 0
    Function Get-Property
    {
      param
      (
        $Node,
        [String[]]$Prefix
      )
 
      $Value = @{Name='Value'; Expression={$_.'#text' }}
      Select-Xml -Xml $Node -XPath 'Property' | ForEach-Object {$i=0} {
        $rv = $_.Node | Select-Object -Property Name, $Value, Path, Type
        $isCollection = $rv.Name -eq 'Property'
 
        if ($isCollection)
        {
          $CollectionItem = "[$i]"
          $i++
          $rv.Path = (($Prefix) -join '.') + $CollectionItem
        }
        else
        {
          $rv.Path = ($Prefix + $rv.Name) -join '.'
        }
 
        $rv
 
        if (Select-Xml -Xml $_.Node -XPath 'Property')
        {
          if ($isCollection)
          {
            $PrefixNew = $Prefix.Clone()
            $PrefixNew[-1] += $CollectionItem
            Get-Property -Node $_.Node -Prefix ($PrefixNew )
          }
          else
          {
            Get-Property -Node $_.Node -Prefix ($Prefix + $_.Node.Name )
          }
        }
      }
    }
  }
 
  Process
  {
    $x++
    $InputObject |
    ConvertTo-Xml -Depth $Depth |
    ForEach-Object { $_.Objects } |
    ForEach-Object { Get-Property $_.Object -Prefix $Prefix$x  } |
    Where-Object { $_.Name -like "$Name" } |
    Where-Object { $_.Value -like $Value } |
    Where-Object { $_.Type -like $Type } |
    Where-Object { $IsNumeric.IsPresent -eq $false -or $_.Value -as [Double] }
  }
}