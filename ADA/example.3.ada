with MACHINE_TYPES; use MACHINE_TYPES;
with MACHINE_TYPES; use MACHINE_TYPES;
with SYSTEM; use SYSTEM;
with UNSIGNED_TYPES; use UNSIGNED_TYPES;


#if ENTORNO = "CROSS" then
-- cambios para poder tratar los pulsos de la antena
-- periscopio de ACRUX

#end if;


package body PACK is

type DT_Enum is 
				(one,
				 two,
				 three);
				
--.ebt
------------------------ VARIABLES ----------------------------------
--.bbv

#if VAR = VAR then

-- Comments
-- Comments
-- Comments
-- Comments
-- Comments
-- Comments

with T_ONE; use T_ONE;
#else
with T_TWO; use T_TWO;

-- Comments
-- Comments
-- Comments
-- Comments
-- Comments
-- Comments

#end if;

with UNSIGNED_TYPES; use UNSIGNED_TYPES;
with UNSIGNED_TYPES; use UNSIGNED_TYPES;
with UNSIGNED_TYPES; use UNSIGNED_TYPES;
with UNSIGNED_TYPES; use UNSIGNED_TYPES;
with UNSIGNED_TYPES; use UNSIGNED_TYPES;

type XC_Struct is access XC_Struct_Ptr;

subtype DT_Subtype is INTEGER range 0..10;

type V_Prueba_Uno is
record
end record;

text

function F_Fun (sdf) return Output_Return_Data_Type;
procedure p1;

function F_Fun (sdf) return Output_Return_Data_Type is

	gfhfghfgh

begin

	return kaka;

end F_Fun;

procedure p1 is

gfhfghfgh

begin

-- comment !

#if VAR then

if VAR_1 = true then
   VAR_2 := VAR_3;
end if;  

asd

#else

if dsfsdfsdf /= klsldf then
	111111
	loop test is
		222222
	end loop;
	333333
else if var = var_2 then
	dsfsfs
else
	sdfsdf
end if;

#end if;

ffff

end p1;

function F_Fun_2 () return Output_Return_Data_Type is

	gfhfghfgh

begin

	return kaka;

end F_Fun_2;

end PACK;
