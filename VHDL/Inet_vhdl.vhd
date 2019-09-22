--------------------------------------------------------------------------
--------------------------------------------------------------------------
-- Associated Professional Systems, Inc.
-- 3003 Latrobe Court, Abingdon, MD 21009
--------------------------------------------------------------------------
--
-- Project:  Example VHDL file for APS X-208 Board
--
-- Date:    02 APR 98
-- Author:    Richard Schwarz
-- Title:    APS-X208 Ram & DIVIDER Example
--
-- Description:
--
-- Contents:    
---
-- Generics:
--
-- Version:  1.0
--
-- Revision History:
--------------------
---------------------------------------------------------------------------
-- Rev:    1.01
-- Date:    12/7/98
-- Author:    R. Schwarz
-- Description: Changed VHDL features to allow use by Synopsys FPGA Express
---------------------------------------------------------------------------
-- Rev:
-- Date:
-- Author:
-- Description:
--
-- SRAM Data offset  3   RW
-- SRAM Address Low  4  W
-- SRAM Address High  5  W
-- SRAM Status    6  W bit0- OE bit1- WE
--
--------------------------------------------------------------------------
--------------------------------------------------------------------------
----------------------------------------------------


--
-- include std_logic library
--
library IEEE;
  use IEEE.std_logic_1164.all;
  USE IEEE.std_logic_arith.all;
  
  
entity MyX208 is
port (
-- FPGA
  A_FPGA    : in unsigned(7 downto 0) ;
  D_FPGA    : inout unsigned(7 downto 0) ;
  RD_FPGA    : in std_ulogic ;
  WR_FPGA    : in std_ulogic ;
  CS_FPGA    : in std_ulogic ;
  Clock_FPGA    : in std_ulogic ;
-- SRAM
  A_SRAM    : out unsigned(14 downto 0);
  D_SRAM    : inout unsigned(7 downto 0);
  CS1_SRAM    : out std_ulogic;
  CS2_SRAM    : out std_ulogic;
  OE_SRAM    : buffer std_ulogic;
  WE_SRAM    : buffer std_ulogic;
  LED3IO163    : buffer std_ulogic;
  Clock_Out    : out std_logic);


-- 
-- set up in numbers of fpga
--
-- sets up fpga pins used to address the test fpga
-- attribute pinnum of A_FPGA : signal is "P22,P21,P18,P16,P15,P7,P6,P5"; 
-- sets up fpga pins used for data fpga
-- attribute pinnum of D_FPGA : signal is "P34,P33,P30,P29,P28,P27,P24,P23";
-- sets up fpga pin used as read strobe 
-- attribute pinnum of RD_FPGA : signal is "P36";
-- sets up fpga pin used as write strobe 
-- attribute pinnum of WR_FPGA : signal is "P42";
-- sets up fpga pin used as CHIP SELECT strobe 
-- attribute pinnum of CS_FPGA : signal is "P35";
-- sets up fpga pin used as strobe 
-- attribute pinnum of CLOCK_FPGA : signal is "P4";
-- sets up fpga pin used as read strobe 
-- attribute pinnum of LED3IO163 : signal is "p163";
-- sets up fpga pin used as clock out 
-- attribute pinnum of Clock_Out : signal is "p165"; 
-- sram address lines 
-- attribute pinnum of OE_SRAM : signal is "P88";
-- attribute pinNum  of WE_SRAM : signal is "P113";
-- attribute pinNum  of CS1_SRAM : signal is "P81";
-- attribute pinnum of CS2_SRAM : signal is   "P82";
-- attribute pinnum of A_SRAM : signal is "P75,P80,P83,P87,P89,P96,P98,P109,P112,P114,P111,P99,P97,P95,P86";
-- ATTRIBUTE PINNUM OF D_SRAM : signal is "p76,p74,p70,p68,P61,P62,P69,P71";
  end;
  

------------------------------------------
------------------------------------------
-- Date    : Mon Jul 07 16:48:20 1997
-- Author    : Gauch (GAL)
--
-- Company    : EIV 
--
-- Description  : DemoLed
--
------------------------------------------
------------------------------------------
architecture bhv of MyX208 is

-------------------------------------------------------------------------
-- control values
-------------------------------------------------------------------------
  constant active    : std_ulogic := '1';
  constant inactive  : std_ulogic := '0';
  constant asserted  : std_ulogic := '1';
  constant negated    : std_ulogic := '0';
  constant lowLevel  : std_ulogic := '0';
  constant highLevel  : std_ulogic := '1';
  constant highLevelWeak: std_ulogic := 'H';
  constant tristate  : std_ulogic := 'Z';

-------------------------------------------------------------------------
-- sizes, dimensions
-------------------------------------------------------------------------
  constant ISADataBitNb    : integer := 8;
  constant indexLEDControl  : integer := 0;
  constant indexLEDValueOUT  : integer := 0;
  constant indexLEDValueIN  : integer := 0;
  constant DivisorMax    : integer := 357142;

-------------------------------------------------------------------------
-- dataflow types
-------------------------------------------------------------------------
  subtype ISADataType is unsigned(ISADataBitNb-1 downto 0);
  subtype CounterIntegerType is integer range 0 to Divisormax;

-------------------------------------------------------------------------
-- signal definition
-------------------------------------------------------------------------
  signal readEnable    : std_ulogic;
  signal writeEnable    : std_ulogic;
  signal RegBuffer      : ISAdatatype;
  signal regControlLED    : ISAdatatype;
  signal regControlLEDValueIN: ISAdatatype;
  signal clock_FPGAInt    : std_ulogic;
  signal clockInt      : std_ulogic;
  signal clockDivCounter  : CounterIntegerType; 
  signal counterDiv    : unsigned(9 downto 0);
  signal SRamDataReg    : unsigned(7 downto 0);
  signal SRamAddrLow    : unsigned(7 downto 0);
  signal SRamAddrHigh    : unsigned(7 downto 0);
  signal SRamStatus    : STD_LOGIC_VECTOR(7 downto 0);

begin


--****************************************
-- General
--****************************************

  readEnable  <= CS_FPGA and RD_FPGA;
  writeEnable <= CS_FPGA and WR_FPGA;
  Clock_Out  <= clock_FPGA;
  
  A_SRAM  <= SRamAddrHigh(6 downto 0) & SRamAddrLow;
  OE_SRAM  <= SRamStatus(0);
  WE_SRAM  <= SRamStatus(1);
  CS1_SRAM  <= SRamAddrHigh(7);
  CS2_SRAM  <= NOT SRamAddrHigh(7);
  
  D_SRAM  <= SRamDataReg when WE_SRAM = '0' AND OE_SRAM = '1' else "ZZZZZZZZ"; 


--****************************************
-- Internal Bus interface 
--****************************************

  ------------------------------------------
  bufferReg: process(readEnable)
  ------------------------------------------
  begin
    if rising_edge(readEnable) then
      case conv_integer(A_FPGA) is
        when 0 => RegBuffer <= regControlLED; -- cache buffer
        when 1 => RegBuffer(0) <=  LED3IO163;
        when 2 => RegBuffer <= regControlLEDValueIN;
        when 3 => RegBuffer <= D_SRAM; -- Read SRAM
        when others => null;
        end case;
    end if;
  end;

  ------------------------------------------
  readAccess: process(readEnable, A_FPGA, RegBuffer)
  ------------------------------------------
  begin
    if readEnable = asserted and 
      (A_FPGA = 0 or A_FPGA = 1 or A_FPGA = 2 or A_FPGA = 3) then
      D_FPGA <= RegBuffer;
    else
      D_FPGA <= (Others => tristate);
    end if;
  end process readAccess;

  ------------------------------------------
  writeAccess: process(writeEnable)
  ------------------------------------------
  begin
    if falling_edge(writeEnable) then
      case conv_integer(A_FPGA) is
        when 0 => regControlLED <= D_FPGA;          
        when 2 => regControlLEDValueIN <= D_FPGA;
        when 3 => SRamDataReg <= D_FPGA;
        when 4 => SRamAddrLow <= D_FPGA;
        when 5 => SRamAddrHigh <= D_FPGA;
        when 6 => SRamStatus <= std_logic_vector(D_FPGA);
        when others => null;
      end case;
    end if;
  end process writeAccess;




--****************************************
-- Test FPGA Core 
--****************************************

  ------------------------------------------
  internalClockDivisor: process(clock_FPGA)
  ------------------------------------------
  begin
    if rising_edge(Clock_FPGA) then
      if (clockDivCounter < (DivisorMax / 2)-1) then 
        clockDivCounter <= clockDivCounter + 1;
      else
        clockDivCounter <= 0;
        Clock_FPGAInt <= not Clock_FPGAInt;
      end if;
    end if;
  end process internalClockDivisor;

  ------------------------------------------
  MuxLEDControl: process(regControlLED,regControlLEDValueIN,Clock_FPGAInt)
  ------------------------------------------
  begin
    if regControlLED(0)='1' then
      LED3IO163 <= regControlLEDValueIN(0);
    else 
      LED3IO163 <= Clock_FPGAInt;
    end if;
  end process MuxLEDControl;



end;

