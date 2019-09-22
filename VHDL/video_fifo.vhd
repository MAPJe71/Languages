-- renoir header_start
-- renoir header_end


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library ram_lib;
use ram_lib.ram_h.all;


  entity video_fifo is
  generic
  port
( 
  wr_clk     : in     std_logic;
  reset_wr   : in     std_logic;

  video      : in     std_logic_vector (data_width -1 downto 0);

  rd_clk     : in     std_logic;
  reset_rd   : in     std_logic;

  video_outp : out    std_logic_vector (data_width -1 downto 0)
);
-- Declarations
end video_fifo;
-- renoir interface_end


architecture video_fifo of video_fifo is

signal write_addr : unsigned (7 downto 0);
signal read_addr  : unsigned (7 downto 0);
signal wr_data    : std_logic_vector(31 downto 0);

signal gnd_stub   : std_logic_vector(15 downto 0);
signal rd_data    : std_logic_vector(31 downto 0);

begin

-----------------------------------------------------------------------------
--                             write control                               --
-----------------------------------------------------------------------------

process (wr_clk)
begin
if wr_clk'event and wr_clk = '1' then

  if reset_wr ='0' then
    write_addr <= (others =>'0');
  else
    write_addr <= write_addr +1;
  end if; 

end if;
end process;

wr_data (wr_data'high downto data_width) <= (others => '0');
wr_data (data_width -1 downto 0) <= video;

gnd_stub <= (others => '0');

-----------------------------------------------------------------------------
--                             connect ram                                 --
-----------------------------------------------------------------------------

  video_ram_0 : entity ram_lib.ramb4_s16_s16
  port map
( 
  clka => wr_clk,
--  rsta => reset_wr,
  rsta => '0',

  wea  => '1',
  ena  => '1',

  addra => std_logic_vector (write_addr),
  dia   => wr_data (15 downto 0),

  clkb => rd_clk,
--  rstb => reset_rd,
  rstb => '0',

  web  => '0',
  enb  => '1',

  addrb => std_logic_vector (read_addr),
  dib   => gnd_stub,
  dob   => rd_data (15 downto 0)
);

  video_ram_1 : entity ram_lib.ramb4_s16_s16
  port map
( 
  clka => wr_clk,
--  rsta => reset_wr,
  rsta => '0',

  wea  => '1',
  ena  => '1',

  addra => std_logic_vector (write_addr),
  dia   => wr_data (31 downto 16),

  clkb => rd_clk,
--  rstb => reset_rd,
  rstb => '0',

  web  => '0',
  enb  => '1',

  addrb => std_logic_vector (read_addr),
  dib   => gnd_stub,
  dob   => rd_data (31 downto 16)
);


-----------------------------------------------------------------------------
--                              read control                               --
-----------------------------------------------------------------------------

process (rd_clk)
begin
if rd_clk'event and rd_clk = '1' then

  if reset_rd ='0' then
    read_addr <= (others =>'0');
  else
    read_addr <= read_addr +1;
  end if; 

  video_outp <= rd_data (data_width -1 downto 0);

end if;
end process;

end video_fifo;
