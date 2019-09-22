function Set-WindowTitle($text)
{
#   (Het-Host).RawUI.WindowTitle = $text
    $Host.UI.RawUI.WindowTitle = $text
}

Set-Alias title Set-WindowTitle
