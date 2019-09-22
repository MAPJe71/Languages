 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library cms_lib;
use cms_lib.types.all;


--------------------------------------------------------------------
-- PACKAGE BODY
--------------------------------------------------------------------

PACKAGE BODY utils IS

-------------------------------------------------------------------------------
-- Copied from numeric_std local functions
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- maximum : returns the maximum of two values
-------------------------------------------------------------------------------
    function maximum (LEFT, RIGHT: INTEGER) return INTEGER is
    begin
        if LEFT > RIGHT then
            return LEFT;
        else
            return RIGHT;
        end if;
    end maximum;

-------------------------------------------------------------------------------
-- minimum : returns the minimum of two values
-------------------------------------------------------------------------------
    function minimum (LEFT, RIGHT: INTEGER) return INTEGER is
    begin
        if LEFT < RIGHT then
            return LEFT;
        else
            return RIGHT;
        end if;
    end minimum;

-------------------------------------------------------------------------------
-- signed_num_bits : returns the number of bits required to represent a signed number
-------------------------------------------------------------------------------
    function SIGNED_NUM_BITS (ARG: INTEGER) return NATURAL is
        variable NBITS: NATURAL;
        variable N: NATURAL;
    begin
        if ARG >= 0 then
            N := ARG;
        else
            N := -(ARG+1);
        end if;

        NBITS := 1;

        while N > 0 loop
            NBITS := NBITS+1;
            N := N / 2;
        end loop;

        return NBITS;

    end SIGNED_NUM_BITS;

-------------------------------------------------------------------------------
-- unsigned_num_bits : returns the number of bits required to represent an unsigned number
-------------------------------------------------------------------------------
    function unsigned_num_bits (arg: natural) return natural is
        variable nbits: natural;
        variable n: natural;
    begin
        n := arg;
        nbits := 1;
        while n > 1 loop
            nbits := nbits+1;
            n := n / 2;
        end loop;
        return nbits;
    end unsigned_num_bits;



-------------------------------------------------------------------------------
-- Overloadings of existing numeric_std functions
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- RESIZE : Resize of STD_LOGIC_VECTOR
-------------------------------------------------------------------------------

    function resize(input: std_logic_vector; new_size : integer)
        return std_logic_vector is
        variable result : std_logic_vector(new_size - 1 downto 0);

    begin
        result := (others => '0');
        for i in 0 to (minimum(new_size, input'length) - 1) loop
                result(i) := input(input'low + i);
        end loop;
        return result;
    end resize;


-------------------------------------------------------------------------------
-- shift_left : shift left of STD_LOGIC_VECTOR
-------------------------------------------------------------------------------

    function shift_left (arg: std_logic_vector; count: natural)
        return std_logic_vector is
        constant arg_l: integer := arg'length-1;
        alias xarg: std_logic_vector(arg_l downto 0) is arg;
        variable result: std_logic_vector(arg_l downto 0) := (others => '0');
        -- exemplar synthesis directives :
--      attribute synthesis_return of result:variable is "sll" ;

    begin
        if count <= arg_l then
            result(arg_l downto count) := xarg(arg_l-count downto 0);
        end if;
        return result;
    end shift_left;


-------------------------------------------------------------------------------
-- shift_right : shift right of STD_LOGIC_VECTOR
-------------------------------------------------------------------------------

    function shift_right (arg: std_logic_vector; count: natural)
        return std_logic_vector is
        constant arg_l: integer := arg'length-1;
        alias xarg: std_logic_vector(arg_l downto 0) is arg;
        variable result: std_logic_vector(arg_l downto 0) := (others => '0');
        -- exemplar synthesis directives :
--      attribute synthesis_return of result:variable is "srl" ;

    begin
        if count <= arg_l then
            result(arg_l-count downto 0) := xarg(arg_l downto count);
        end if;
        return result;
    end shift_right;


-------------------------------------------------------------------------------
-- TO_INTEGER : from BOOLEAN
-------------------------------------------------------------------------------

    function to_integer(bool : boolean)
        return integer is
    begin
        if (bool = true) then
            return (1);
        else
            return(0);
        end if;
    end to_integer;


-------------------------------------------------------------------------------
-- TO_INTEGER : from STD_LOGIC_VECTOR
-------------------------------------------------------------------------------

    function to_integer(num : std_logic_vector)
        return integer is
        variable result, bit_value : INTEGER;

    begin
        result := 0;
        bit_value := 1;

        for i in num'low to num'high loop
            if num(i) = '1' then
                result := result + bit_value;
            end if;
            bit_value := bit_value * 2;
        end loop;

        return result;
    end to_integer;


-------------------------------------------------------------------------------
-- TO_SIGNED : from STD_LOGIC_VECTOR
-------------------------------------------------------------------------------

    function to_signed(num : std_logic_vector)
        return SIGNED is
        variable result : SIGNED(num'length - 1 DOWNTO 0);

    begin
        for i in 0 to num'length - 1 loop
            result(i) := num(i + num'low);
        end loop;

        return result;
    end to_signed;


-------------------------------------------------------------------------------
-- TO_UNSIGNED : from STD_LOGIC_VECTOR
-------------------------------------------------------------------------------

    function to_unsigned(num : std_logic_vector)
        return UNSIGNED is
        variable result : UNSIGNED(num'length - 1 DOWNTO 0);

    begin
        for i in 0 to num'length - 1 loop
            result(i) := num(i + num'low);
        end loop;

        return result;
    end to_unsigned;


-------------------------------------------------------------------------------
-- "+" : STD_LOGIC_VECTOR + natural
-------------------------------------------------------------------------------
    function "+" (L: std_logic_vector; R: natural) 
        return std_logic_vector is

    begin
        return (std_logic_vector(unsigned(l) + r));
    end "+";


-------------------------------------------------------------------------------
-- "+" : STD_LOGIC_VECTOR + STD_LOGIC_VECTOR
-------------------------------------------------------------------------------
    function "+" (L: std_logic_vector; R: std_logic_vector) 
        return std_logic_vector is

    begin
        return (std_logic_vector(unsigned(l) + unsigned(r)));
    end "+";


-------------------------------------------------------------------------------
-- "-" : STD_LOGIC_VECTOR + natural
-------------------------------------------------------------------------------
    function "-" (L: std_logic_vector; R: natural) 
        return std_logic_vector is

    begin
        return (std_logic_vector(unsigned(l) - r));
    end "-";


-------------------------------------------------------------------------------
-- "-" : STD_LOGIC_VECTOR + STD_LOGIC_VECTOR
-------------------------------------------------------------------------------
    function "-" (L: std_logic_vector; R: std_logic_vector) 
        return std_logic_vector is

    begin
        return (std_logic_vector(unsigned(l) - unsigned(r)));
    end "-";


-------------------------------------------------------------------------------
-- "=" : Compare STD_LOGIC_VECTOR with natural
-------------------------------------------------------------------------------
    function "=" (l: std_logic_vector; r: natural) 
        return boolean is

    begin
        return (unsigned(l) = r);
    end "=";


-------------------------------------------------------------------------------
-- "=" : Compare natural with STD_LOGIC_VECTOR
-------------------------------------------------------------------------------
    function "=" (l: natural; r: std_logic_vector) 
        return boolean is

    begin
        return (l = unsigned(r));
    end "=";


-------------------------------------------------------------------------------
-- custom functions utility functions 
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- maximum : returns the maximum of three values
-------------------------------------------------------------------------------
    function maximum (left, middle, right: integer) return integer is
    begin
        return maximum(left, maximum(middle, right));
    end maximum;

-------------------------------------------------------------------------------
-- maximum : returns the maximum of four values
-------------------------------------------------------------------------------
    function maximum (data0, data1, data2, data3: integer) return integer is
    begin
        return maximum(maximum(data0, data1), maximum(data2, data3));
    end maximum;

-------------------------------------------------------------------------------
-- TO_std_logic : from BOOLEAN
-------------------------------------------------------------------------------
    function to_std_logic(bool : boolean)
        return std_logic is
    begin
        if (bool = true) then
            return ('1');
        else
            return('0');
        end if;
    end to_std_logic;


-------------------------------------------------------------------------------
-- to_std_logic_vector : from std_logic
-------------------------------------------------------------------------------
    function to_std_logic_vector(arg : std_logic; size : integer) 
        return std_logic_vector is
        variable result : std_logic_vector(size - 1 downto 0);

    begin
        for i in 0 to size - 1 loop
                result(i) := arg;
        end loop;
        return result;
    end to_std_logic_vector;


--------------------------------------------------------------------
-- to_hex_String - generates a hex string of length 'length', corresponding to 'num'
--------------------------------------------------------------------
    function to_hex_string(num : unsigned; length : integer)
        return string is

        constant hex_string : STRING(1 TO 16) := "0123456789ABCDEF";
        variable result : STRING(1 to length);

    begin

        for i in 0 to length-1 LOOP
            result(i+1):=hex_string(1+ to_integer(num(i*4+3 downto i*4)));
        end loop;
        return result;
    end;


-------------------------------------------------------------------------------
-- select_data - selects data based on sel - std_logic_vector version
-------------------------------------------------------------------------------
    function select_data(data0, data1 : std_logic_vector; sel : boolean)
        return std_logic_vector is
    begin
        if (sel) then
            return (data1);
        else
            return (data0);
        end if;
    end select_data;


-------------------------------------------------------------------------------
-- select_data - selects data based on sel - integer
-------------------------------------------------------------------------------
    function select_data(data0, data1 : integer; sel : boolean)
        return integer is
    begin
        if (sel) then
            return (data1);
        else
            return (data0);
        end if;
    end select_data;


-------------------------------------------------------------------------------
-- select_data - selects data based on sel - string
-------------------------------------------------------------------------------
    function select_data(data0, data1 : string; sel : boolean)
        return string is
    begin
        if (sel) then
            return (data1);
        else
            return (data0);
        end if;
    end select_data;


-------------------------------------------------------------------------------
-- ram_string - creates a hex string from the bit "bit" of the values of an int_array
-- This is used for the initial values of LUT RAM
-------------------------------------------------------------------------------

    function ram_string(data : integer_array;slice_width,slice_depth,slice_pos,slice_start,array_width: integer) return string is
    variable tmp_unsigned : unsigned(array_width-1 downto 0);
    variable tmp_string :   unsigned(slice_width*slice_depth-1 downto 0);
    begin
        for i in 0 to slice_depth-1 loop
            tmp_unsigned := to_unsigned(data(i+slice_start),array_width);
            for u in slice_width-1 downto 0 loop
                if tmp_unsigned(slice_pos*slice_width+u) ='0' then
                    tmp_string(u+i*slice_width) :='0';
                else
                    tmp_string(u+i*slice_width) :='1';
                end if;
            end loop;
        end loop;
        return to_hex_string(tmp_string,(slice_width*slice_depth)/4);
    end ram_string;

-------------------------------------------------------------------------------
-- to_slv - converts a string to an std logic vector
-------------------------------------------------------------------------------

    function to_slv(data : string) return std_logic_vector is
    variable vec :std_logic_vector(data'high*4 -1 downto (data'low-1) *4 );
    constant hex_string : STRING(1 TO 16) := "0123456789ABCDEF";
    begin
        for i in data'low to data'high loop
            for u in 1 to 16 loop
                if data(i) = hex_string(u) then
                    vec(i*4-1 downto i*4-4) := std_logic_vector(to_unsigned(u-1,4));
                end if;
            end loop;
        end loop;
        return vec;
    end to_slv;


-------------------------------------------------------------------------------
-- split_array_even - splits out the even elements of an array
-------------------------------------------------------------------------------
    function split_array_even(input_array : integer_array)
            return integer_array is

        variable even_array : integer_array (0 to input_array'high / 2);

    begin
        for i in 0 to even_array'high loop
            even_array(i) := input_array(i * 2);
        end loop;
        return even_array;
    end split_array_even;


-------------------------------------------------------------------------------
-- split_array_odd - splits out the odd elements of an array
-------------------------------------------------------------------------------
    function split_array_odd(input_array : integer_array)
            return integer_array is

        variable odd_array : integer_array (0 to input_array'high / 2);

    begin
        for i in 0 to odd_array'high loop
            odd_array(i) := input_array(i * 2 + 1);
        end loop;
        return odd_array;
    end split_array_odd;


-------------------------------------------------------------------------------
-- to_integer_array - from real array
-------------------------------------------------------------------------------
    function to_integer_array(in_array : real_array; scale : real)
        return integer_array is

        variable out_array : integer_array (0 to in_array'high);

    begin
        for i in 0 to out_array'high loop
            out_array(i) := integer(in_array(i) * scale);
        end loop;
        return out_array;
    end to_integer_array;


-------------------------------------------------------------------------------
-- array_fill - expands a smaller array into a larger one
-------------------------------------------------------------------------------
    function array_expand(in_array : integer_array; out_size : integer)
        return integer_array is
        variable out_array : integer_array(0 to out_size - 1) := (others => 0);
    begin
        for i in 0 to in_array'high loop
            out_array(i) := in_array(i);
        end loop;
        return out_array;
    end array_expand;


-------------------------------------------------------------------------------
-- calc_bits_needed - calculates the number of bits needed to interpolate the differences between consecutive values of 
-- a fixed array 
-------------------------------------------------------------------------------
    function calc_bits_needed(data : integer_array) return integer is
       variable max_diff   : integer := 0;
       variable diff      : integer;
    begin
       for i in 1 to data'high loop
          diff := abs(data(i) - data(i-1));
          if diff > max_diff then
             max_diff := diff;
          end if;
       end loop;

    --   diff := abs(data(0) - data(data'high));
    --   if diff > max_diff then
    --      max_diff := diff;
    --   end if;

       return (unsigned_num_bits(max_diff) + 1);
    end calc_bits_needed;

end utils;
--------------------------------------------------------------------
