<html>
<head>
<%
function meineFunktion(num1,num2)
response.write(num1*num2)
end function

sub meineProzedur()
Befehle
end sub

sub meineProzedur(argument1, argument2, etc.)
Befehle
end sub
%>
</head>

<body>
Das Resultat ist: <%=meineFunktion(3,4)%>
</body>

</html>