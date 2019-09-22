-- OK
function Func1()
end

-- wird erkannt
Func2 = function()
end

-- Falsch angezeigt / Syntaxfehler (ungültige Funktionsdefinition)
Func3 = function Err()
end

SomeClass = {};

-- wird erkannt
function SomeClass:Func4()
end

-- wird erkannt
function SomeClass.Func5()
end

-- wird erkannt
SomeClass.Func6 = function()
end

-- wird erkannt
func7=function()
end

-- wird nicht erkannt
func8 =
    function()
end

-- wird nicht erkannt
func9
    = function()
end

-- wird erkannt
function func10() test(); end

-- wird erkannt
function func11() if ok() then test(); end
   nocheintest();
end

-- wird erkannt
function func12()
 end

-- wird erkannt
 function func13()
end
