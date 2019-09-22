-- https://www.adahome.com/Discover/Examples/multiprocessing.ada
Problem:
  How to make N computations (e.g. compute the determinants of ten 5x5
  matrices) in parallel using the  multiprocessing capabilities of Ada
  (and of your implicit parallel computer).


Solution:
  Date: Wed, 14 Dec 1994
  From: petrick@beowulf.aero.org (Bruce Petrick)
  Updated: Mon, 19 Dec 1994 [BP, MK]

-- Here is one solution.  I have taken the liberty of abstracting out
-- the "messy" tasking business inside a reusable generic package and
-- adding a support package to output elapsed seconds with each print
-- statement.  This solution works both for Ada-83 and Ada-95.
--
-- Bruce Petrick
-- The Aerospace Corporation
-- petrick@aero.org
-- (310) 336-2319


generic
   type Operand is private;
   with function Operate ( On_What : in Operand )
          return Operand;

package Task_Code_Wrapper is

   type Operator is limited private;

   procedure Startup ( Actor : in Operator; Start : in Operand );
   procedure Results ( Actor : in Operator; Found : out Operand );

private

   task type Operator_Task is
      entry Startup ( Start : in Operand );  -- use to start task with a value.
      entry Results ( Found : out Operand ); -- use to retrieve computed value.
   end Operator_Task;

   type Operator is record
       Actor : Operator_Task;
   end record;

end Task_Code_Wrapper;



package body Task_Code_Wrapper is

   task body Operator_Task is
      Value : Operand;
   begin
      accept Startup ( Start : in Operand ) do
         -- only store the value in this accept statement.
         Value := Start;
      end Startup;

      -- actions here can take place in parallel with other tasks...
      Value := Operate ( Value );

      -- now wait until someone wants the result.
      accept Results ( Found : out Operand ) do
         Found := Value; -- return the result and terminate.
      end Results;
   end Operator_Task;


   procedure Startup ( Actor : in Operator; Start : in Operand ) is
   begin
       Actor.Actor.Startup ( Start );
   end Startup;


   procedure Results ( Actor : in Operator; Found : out Operand ) is
   begin
       Actor.Actor.Results ( Found );
   end Results;

end Task_Code_Wrapper;



package Task_Main_Support is

   procedure Print ( Text : in String );
   -- Output the current elapsed time in seconds with the text.

end Task_Main_Support;



with Text_IO;
with Calendar;

package body Task_Main_Support is

   Was : constant Standard.Duration := Calendar.Seconds ( Calendar.Clock );

   package Time_IO is new Text_IO.Fixed_IO ( Standard.Duration );


   procedure Print ( Text : in String ) is
      Now : Standard.Duration := Calendar.Seconds ( Calendar.Clock ) - Was;
      Tag : String ( 1 .. 6 );
   begin
      Time_IO.Put ( Tag, Now, Aft => 3, Exp => 0 );
      Text_IO.Put_Line ( "Time " & Tag & ": " & Text );
   end Print;

end Task_Main_Support;



with Task_Main_Support;
with Task_Code_Wrapper;

procedure Task_Main_Example is

   type Operand_Type is range 0 .. 1_000_000; -- whatever....

   function Some_Function ( What : in Operand_Type )
     return Operand_Type;

   package Ops is
     new Task_Code_Wrapper
       ( Operand => Operand_Type,
         Operate => Some_Function );

   type Operator_List is
     array ( Operand_Type range <> ) of
       Ops.Operator;

   -- Declare a list of tasks that will do the work.
   List : Operator_List ( 1 .. 10 );
   Find : Operand_Type; -- temporary variable...


   procedure Print ( Text : in String )
     renames Task_Main_Support.Print;


   function Some_Function ( What : in Operand_Type )
     return Operand_Type is
   begin
      delay 1.0; -- simulate an action that takes a long time, but
                 -- that can run simultaneously with other actions.
      return What * 2;
   end Some_Function;


begin
   Print ( "At start." );
   -- First give all 10 running tasks a value to work on.
   for Fill in List'range loop
       Ops.Startup ( List ( Fill ), Fill );
   end loop;

   Print ( "After all initialized." );
   -- At this point, all tasks are running on their respective values.

   -- Get results from each task when ready ...
   for Fill in List'range loop
       Ops.Results ( List ( Fill ), Find );
       Print ( "Result (" & Operand_Type'Image ( Fill ) & " ) =>" &
              Operand_Type'Image ( Find ) );
   end loop;
   Print ( "All done." );
end Task_Main_Example;


-- Sample Output =>
-- 
-- Time  0.010: At start.
-- Time  0.020: After all initialized.
-- Time  1.020: Result( 1 ) => 2
-- Time  1.020: Result( 2 ) => 4
-- Time  1.020: Result( 3 ) => 6
-- Time  1.020: Result( 4 ) => 8
-- Time  1.030: Result( 5 ) => 10
-- Time  1.030: Result( 6 ) => 12
-- Time  1.030: Result( 7 ) => 14
-- Time  1.030: Result( 8 ) => 16
-- Time  1.030: Result( 9 ) => 18
-- Time  1.030: Result( 10 ) => 20
-- Time  1.040: All done.
--
-- (note that without tasking, this would have taken at least 10 seconds)

