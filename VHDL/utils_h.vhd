--------------------------------------------------------------------
-- utils.vhd
--
-- General purpose utilities
--
-- V0.1 04/03/2000  Fixed problem with 'resize' - added input'low to expression
-- V0.2 07/03/2000  Added host/cpu read/write procedures
-- V0.3 14/12/2000  Split out dve_utils into separate package
-- V0.4 1/3/2000    updates for blockRAM:
--                  "to_hex_string" updated to cope with longer strings
--                  "to_slv" added
--                  "ram_string" added
--
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library cms_lib;
use cms_lib.types.all;


package utils is

-------------------------------------------------------------------------------
-- Copied from numeric_std local functions
-------------------------------------------------------------------------------
    function maximum (left, right: integer) return integer;
    function minimum (left, right: integer) return integer;
    function signed_num_bits (arg: integer) return natural;
    function unsigned_num_bits (arg: natural) return natural;

-------------------------------------------------------------------------------
-- Overloadings of existing numeric_std functions
-------------------------------------------------------------------------------
    function resize(input: std_logic_vector; new_size : integer) return std_logic_vector;
    function shift_left (arg: std_logic_vector; count: natural) return std_logic_vector;
    function shift_right (arg: std_logic_vector; count: natural) return std_logic_vector;
    function to_integer(bool : boolean) return integer;
    function to_integer(num : std_logic_vector) return integer;
    function to_signed(num : std_logic_vector) return SIGNED;
    function to_unsigned(num : std_logic_vector) return UNSIGNED;
    function "+" (L: std_logic_vector; R: natural) return std_logic_vector;
    function "+" (L: std_logic_vector; R: std_logic_vector) return std_logic_vector;
    function "-" (L: std_logic_vector; R: natural) return std_logic_vector;
    function "-" (L: std_logic_vector; R: std_logic_vector) return std_logic_vector;
    function "=" (L: std_logic_vector; R: natural) return boolean;
    function "=" (L: natural; R: std_logic_vector) return boolean;

-------------------------------------------------------------------------------
-- custom functions / utility functions
-------------------------------------------------------------------------------
    function maximum (left, middle, right: integer) return integer;
    function maximum (data0, data1, data2, data3: integer) return integer;
    function to_std_logic(bool : boolean) return std_logic;
    function to_std_logic_vector(arg : std_logic; size : integer) return std_logic_vector;
    function to_hex_string(num : unsigned; length : integer) return string;
    function select_data(data0, data1 : std_logic_vector; sel : boolean) return std_logic_vector;
    function select_data(data0, data1 : integer; sel : boolean) return integer;
    function select_data(data0, data1 : string; sel : boolean) return string;
    function ram_string(data : integer_array;slice_width,slice_depth,slice_pos,slice_start,array_width: integer) return string;
    function to_slv(data : string) return std_logic_vector;

    function split_array_even(input_array : integer_array) return integer_array;
    function split_array_odd(input_array : integer_array) return integer_array;

    function to_integer_array(in_array : real_array; scale : real) return integer_array;
    function array_expand(in_array : integer_array; out_size : integer) return integer_array;
    function calc_bits_needed(data : integer_array) return integer;
end;

