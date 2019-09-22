<#
.SYNOPSIS
   <A brief description of the script>
.DESCRIPTION
   <A detailed description of the script>
.PARAMETER <paramName>
   <Description of script parameter>
.EXAMPLE
   <An example of using the script>
#>

# Use it like this:
#	PS> Format-XML ([xml](cat c:\ps\r_and_j.xml)) -indent 4
#
function Format-XML ([xml]$xml, $indent=2)
{
    $stringWriter = New-Object System.IO.StringWriter
    $xmlWriter = New-Object System.XMl.XmlTextWriter $stringWriter
    $xmlWriter.Formatting = "indented"
    $xmlWriter.Indentation = $Indent
    $xml.WriteContentTo($xmlWriter)
    $xmlWriter.Flush()
    $stringWriter.Flush()
    Write-Output $stringWriter.ToString()
}
