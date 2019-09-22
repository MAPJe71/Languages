-- About ADA procedures just to let you know in order to have ideas for future
-- versions, that was a simple procedure struct... a complex one could be (were
-- elements inside [] are optional):

-- Example 1 - Complex and all in same line:

procedure P_Procedure_Example_1 ( parameter_1 : in Data_Tipe_1 ; parameter_2 : in out Data_Tipe_2 ; parameter_N : [in] [out] Data_Tipe_N ) is

-- Example 2 - Complex split lines:

procedure P_Procedure_Example_2 ( parameter_1 : in Data_Tipe_1 ;
parameter_2 : in out Data_Tipe_2 ;
parameter_N : [in] [out] Data_Tipe_N ) is

-- "is" could be even in a different line ! that is why "is" is the best key !

-- ADA also provide with functions like in these examples:

-- Example 1 - Complex and all in same line:

function F_Function_Example_1 ( parameter_1 : in Data_Tipe_1 ; parameter_2 : in out Data_Tipe_2 ; parameter_N : [in] [out] Data_Tipe_N ) return Output_Return_Data_Type is

-- Example 2 - Complex split lines:

function F_Function_Example_2 ( parameter_1 : in Data_Tipe_1 ;
parameter_2 : in out Data_Tipe_2 ;
parameter_N : [in] [out] Data_Tipe_N )
return Output_Return_Data_Type is

-- That's why regular expressions normally works perfect, since you have optional.
-- Something that could cover both these examples and the others like
-- declarations (procedures/functions without "is") with regex could be equal or
-- similar to:
--
--      "(procedure|function) (( * )?)(a-zA-Z0-9?)( (( * )?)|;|is|()"
--
-- Anyway I will keep reading news about this ! I know it is not an easy task !
-- All work around notepad++ is amazing ! you're doing very well !

-- TY !