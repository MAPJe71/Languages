-- renoir header_start
-- renoir header_end

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library mixer_rd;
use mixer_rd.delays_h2.all;


  entity upsample_444 is
  generic
( 
  data_width   : integer := 12;
  data_delay   : integer := 10
);
  port
( 
  clk          : in   std_logic;

  u_sel        : in   std_logic;

  y_inp        : in   std_logic_vector (data_width -1 downto 0);
  c_inp        : in   std_logic_vector (data_width -1 downto 0);

  y_out        : out  std_logic_vector (data_width -1 downto 0);
  u_out        : out  std_logic_vector (data_width -1 downto 0);
  v_out        : out  std_logic_vector (data_width -1 downto 0)
);
-- Declarations
end upsample_444;
-- renoir interface_end
architecture upsample_444 of upsample_444 is

signal u_sl         : std_logic;
signal u_mem        : std_logic_vector (data_width -1 downto 0);

signal v_sel        : std_logic;
signal v_mem        : std_logic_vector (data_width -1 downto 0);

begin

-----------------------------------------------------------------------------
--                          chroma interpolator                            --
-----------------------------------------------------------------------------

process (clk)
begin
if rising_edge(clk) then

  u_sl <= not (u_sel);

  if u_sl ='1' then
    u_mem <= c_inp;
  else
    u_mem <= u_mem;
  end if;

  v_sel <= u_sel;

  if v_sel ='1' then
    v_mem <= c_inp;
  else
    v_mem <= v_mem;
  end if;
  
end if; 
end process;


-----------------------------------------------------------------------------
--                      compensating delay for luma                        --
-----------------------------------------------------------------------------

       -- compensating delay for y

  y_delay : delayv
  generic map
( 
  width  => data_width,
  length => data_delay
)
  port map
( 
  clk => clk,

  d => y_inp,
  q => y_out
);

       -- compensating delay for u

  u_delay : delayv
  generic map
( 
  width  => data_width,
  length => data_delay -1
)
  port map
( 
  clk => clk,

  d => u_mem,
  q => u_out
);

  v_delay : delayv
  generic map
( 
  width  => data_width,
  length => data_delay -2
)
  port map
( 
  clk => clk,

  d => v_mem,
  q => v_out
);


end;
