
-------------------------------------------------------------------------
-- Fibonacci sequence generator.
--
-- Copyright 1995, Accolade Design Automation, Inc.
--
library ieee;
use ieee.std_logic_1164.all;

entity fib is
   port (Clk,Clr: in std_ulogic;
         Load: in std_ulogic;
         Data_in: in std_ulogic_vector(15 downto 0);
         S: out std_ulogic_vector(15 downto 0));
end entity fib;

architecture behavior of fib is
    signal Restart,Cout: std_ulogic;
    signal Stmp: std_ulogic_vector(15 downto 0);
    signal A, B, C: std_ulogic_vector(15 downto 0);
    signal Zero: std_ulogic;
    signal CarryIn, CarryOut: std_ulogic_vector(15 downto 0);
    
begin
    P1: process(Clk)
    begin
        if rising_edge(Clk) then
             Restart <= Cout;
        end if;
    end process P1;

    Stmp <= A xor B xor CarryIn;
    Zero <= '1' when Stmp = "0000000000000000" else '0';

    CarryIn <= C(15 downto 1) & '0';
    CarryOut <= (B and A) or ((B or A) and CarryIn);
    C(15 downto 1) <= CarryOut(14 downto 0);
    Cout <= CarryOut(15);

    P2: process(Clk,Clr,Restart)
    begin
        if Clr = '1' or Restart = '1' then
            A <= "0000000000000000";
            B <= "0000000000000000";
        elsif rising_edge(Clk) then
            if Load = '1' then
                A <= Data_in;
            elsif Zero = '1' then
                A <= "0000000000000001";
            else
                A <= B;
            end if;
            B <= Stmp;
        end if;
    end process P2;

    S <= Stmp;

end behavior;



-------------------------------------------------------
-- Test bench
--
-- Copyright 1995, Accolade Design Automation, Inc.
--
 
library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use work.fib;    -- Get the design out of library 'work'
 
entity testfib is
end entity testfib;
 
architecture stimulus of testfib is
    component fib
       port (Clk,Clr: in std_ulogic;
             Load: in std_ulogic;
             Data_in: in std_ulogic_vector(15 downto 0);
             S: out std_ulogic_vector(15 downto 0));
    end component;
 
    function str_to_stdvec(inp: string) return std_ulogic_vector is
    variable temp: std_ulogic_vector(inp'range) := (others => 'X');
    begin
        for i in inp'range loop
            if (inp(i) = '1') then
                temp(i) := '1';
            elsif (inp(i) = '0') then
                temp(i) := '0';
            end if;
        end loop;
        return temp;
    end;
 
    function stdvec_to_str(inp: std_ulogic_vector) return string is
    variable temp: string(inp'left+1 downto 1) := (others => 'X');
    begin
        for i in inp'reverse_range loop
            if (inp(i) = '1') then
                temp(i+1) := '1';
            elsif (inp(i) = '0') then
                temp(i+1) := '0';
            end if;
        end loop;
        return temp;
    end;
 
    signal Clk,Clr: std_ulogic;
    signal Load: std_ulogic;
    signal Data_in: std_ulogic_vector(15 downto 0);
    signal S: std_ulogic_vector(15 downto 0);
    signal done: std_ulogic := '0';
 
    constant PERIOD: time := 50 ns;
 
--    for DUT: fib use entity work.fib(behavior);
 
begin
    DUT: fib port map(Clk=>Clk,Clr=>Clr,Load=>Load,
                      Data_in=>Data_in,S=>S);
 
    Clock: process
        variable c: std_ulogic := '0';
    begin
        while (done = '0') loop
            wait for PERIOD/2;
            c := not c;
            Clk <= c;
        end loop;
    end process Clock;  
 
STIMBLOCK: block
begin
    Read_input: process  
        file vector_file: text;
 
        variable stimulus_in: std_ulogic_vector(33 downto 0);
        variable S_expected: std_ulogic_vector(15 downto 0);
        variable str_stimulus_in: string(34 downto 1);
        variable err_cnt: integer := 0;
        variable file_line: line;
 
    begin
 
        FILE_OPEN(vector_file,"tfib93.vec",READ_MODE);
 
        wait until rising_edge(Clk);
 
        while not endfile(vector_file) loop
            readline (vector_file,file_line);
            read (file_line,str_stimulus_in) ;
            assert (false)
                report "Vector: " & str_stimulus_in
                severity note;
            stimulus_in := str_to_stdvec (str_stimulus_in);
 
            wait for 1 ns;
 
            --Get input side of vector...
            Clr <= stimulus_in(33);
            Load <= stimulus_in(32);
            Data_in <= stimulus_in(31 downto 16);
 
            --Put output side (expected values) into a variable...
            S_expected := stimulus_in(15 downto 0);
 
            wait until falling_edge(Clk);
 
            --Check the expected value against the results...
            if (S /= S_expected) then
                err_cnt := err_cnt + 1;
                assert false
                    report "Vector failure!" & lf &
                    "Expected S to be  " & stdvec_to_str(S_expected) & lf &
                    "but its value was " & stdvec_to_str(S) & lf
                    severity note;
            end if;
        end loop;
 
        FILE_CLOSE(vector_file);
 
        done <= '1';
 
        if (err_cnt = 0) then
            assert false
                report "No errors." & lf & lf
                severity note;
        else
            assert false
                report "There were errors in the test." & lf
                severity note;
        end if;
        wait;
 
    end process;
 
end block STIMBLOCK;
 
end architecture stimulus;






