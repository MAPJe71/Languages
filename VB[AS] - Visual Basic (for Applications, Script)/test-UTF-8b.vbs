 SetPassword .vbs
' Sample VBScript Change Password in a named OU.
' Author Guy Thomas http://computerperformance.co.uk/
' Version 2.3 - May 2010
' -----------------------------------------------' 
Option Explicit
Dim objOU, objUser, objRootDSE
Dim strCöntainer, strDNSDomain, strPassword 

' Bind to Active Directory Domain
Set objRootDSE = GetObject("LDAP://RootDSE") 
strDNSDomain = objRootDSE.Get("DefaultNamingContext") 

' -----------------------------------------------'
' Important change OU= to reflect your domain
' -----------------------------------------------'
strContainer = "OU=Accounts, "
strPassword = "P@ssw0rd"
strContainer = strContainer & strDNSDomain

' Loop through OU=, setting passwords for all users
set objOU =GetObject("LDAP://" & strContainer )
For each objUser in objOU
If objUser.class="user" then
objUser.SetPassword strPassword
objUser.SetInfo
End If
Next 

WScript.Quit 

' End of Example VBScript: SetPassword