-- Procedure example 1:

procedure P_Procedure_1 is
-- code
begin
-- code
end P_Procedure;

-- Procedure example 2:

procedure P_Procedure_1;

-- TYPES EXAMPLES:

-- Types example 1:

type T_Enum_Example is (one,two,three);

-- Types example 2:

subtype T_Subtype_Example is INTEGER range 1..100 ;

-- Types example 2:

type T_Struct_Example is
record
var_1 : INTEGER;
var_2 : INTEGER;
end record;

-- Types example 3:

type T_Array_Example is array 1..10 of INTEGER;

-- DECLARES EXAMPLES:

declare
-- code
begin
--code
end;

-- CONDITIONAL EXAMPLES:

if condition then
else if condition then
else if condition and condition_2 then
else if condition and then condition_2 and condition_3 then
else
end if;

-- PRECOMPILATION CONDITIONAL EXAMPLES:

-- I use semicolons (") to avoid the web editor to turn the lines in upper case.

#if
#elsif
#else
#end if;

-- VAR declaration and asignation example:

VAR_1 : INTEGER := 1;
