-- renoir header_start
-- renoir header_end

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library timer;
use timer.smpte.all;

library mixer_rd;
use mixer_rd.utils.all;

  entity video_analyser_test is
  generic
( 
  video_width    : integer := 11;
  cpu_data_width : integer := 16
);
  port
( 
  clk83         : out    std_logic;
  reset         : out    std_logic;
  reset_fifo    : out    std_logic;

  f             : out    std_logic; 
  f_imp         : out    std_logic; 
  not_frame_imp : out    std_logic; 

  smpte_mode    : out    std_logic_vector (3 downto 0);
  
  htot          : out    std_logic_vector (12 downto 0);
  hact          : out    std_logic_vector (12 downto 0);
  hbp           : out    std_logic_vector (9 downto 0);
  vact_f1       : out    std_logic_vector (11 downto 0);
  vact_f2       : out    std_logic_vector (11 downto 0);
  vbp_f1        : out    std_logic_vector (7 downto 0);
  vbp_f2        : out    std_logic_vector (7 downto 0);
  vtot_f1       : out    std_logic_vector (11 downto 0);
  vtot_f2       : out    std_logic_vector (11 downto 0);
  scan_mode     : out    std_logic;

  tile_delay    : out    unsigned (7 downto 0);
  dfifo_delay   : out    std_logic_vector (7 downto 0);

  y_max_limit   : out    unsigned (video_width -2 downto 0);
  y_min_limit   : out    unsigned (video_width -2 downto 0);

  c_max_limit   : out    unsigned (video_width -2 downto 0);
  c_min_limit   : out    unsigned (video_width -2 downto 0);

  cm_save_line  : out    std_logic;
  
  field_number  : out    std_logic;
  line_number   : out    unsigned (10 downto 0);

  y_data        : out    std_logic_vector (video_width -2 downto 0);
  c_data        : out    std_logic_vector (video_width -2 downto 0);

  rd_addr       : out    std_logic_vector (10 downto 0)
);
-- Declarations
end video_analyser_test;
-- renoir interface_end

architecture video_analyser_test of video_analyser_test is

constant t_hold : time:= 2 ns; -- hold time for CPU bus

signal clk    : std_logic;


-----------------------------------------------------------------------------
--                                 Delay                                   --
-----------------------------------------------------------------------------
  
  procedure delay (
    signal   clk   : in    std_logic;
    n_pulses       : in    integer) is 
    
  begin
    
    for i in 1 to n_pulses loop 
         
       wait until rising_edge(clk);
  
     end loop;

    wait for t_hold;    
    
  end delay;  


-----------------------------------------------------------------------------
--                              Set video mode                             --
-----------------------------------------------------------------------------

  procedure set_video_mode 
(

  video_mode       : in    integer;
  
  signal htot      : out    std_logic_vector (12 downto 0);
  signal hact      : out    std_logic_vector (12 downto 0);
  signal hbp       : out    std_logic_vector (9 downto 0);
  signal vact_f1   : out    std_logic_vector (11 downto 0);
  signal vact_f2   : out    std_logic_vector (11 downto 0);
  signal vbp_f1    : out    std_logic_vector (7 downto 0);
  signal vbp_f2    : out    std_logic_vector (7 downto 0);
  signal vtot_f1   : out    std_logic_vector (11 downto 0);
  signal vtot_f2   : out    std_logic_vector (11 downto 0);
  signal scan_mode : out    std_logic
) is 
begin
  
       -- horizontal timing (output)

  htot <= conv_std_logic_vector (4096-(timing(video_mode).htot-1),13);
  hact <= conv_std_logic_vector (4096-(timing(video_mode).hact-1),13);
  hbp  <= conv_std_logic_vector (512-(timing(video_mode).hbp),10);

       -- vertical timing (output)

  vtot_f1   <= conv_std_logic_vector (2048-(timing(video_mode).vtot_f1-1),12);
  vtot_f2   <= conv_std_logic_vector (2048-(timing(video_mode).vtot_f2-1),12);

  vact_f1   <= conv_std_logic_vector (2048-(timing(video_mode).vact_f1-1),12);
  vact_f2   <= conv_std_logic_vector (2048-(timing(video_mode).vact_f2-1),12);

  vbp_f1    <= conv_std_logic_vector (128-(timing(video_mode).vbp_f1-1),8);
  vbp_f2    <= conv_std_logic_vector (128-(timing(video_mode).vbp_f2-1),8);

  scan_mode <= timing(video_mode).scan_mode;
    
end set_video_mode;



begin

       -- make system clock

clk_gen : process
begin  

  clk   <= '0';
  wait for 5 ns;
  clk   <= '1';
  wait for 5 ns;    

end process clk_gen;
  
clk83 <= clk;  
  
  -- make system reset
  
process
begin 
  
  reset <= '0';
  wait for 5 ns;
  reset <= '1';
  wait for 5 ns;
  reset <= '0';
  wait;

end process;

       -- main process

process

constant video_mode   : integer := 4;

begin 

  f <= '1';
  f_imp <= '0';
  not_frame_imp <= '1';

  y_data <= (others => '0');
  c_data <= (others => '0');

  tile_delay  <= to_unsigned (40, 8);
  dfifo_delay <= (others => '0');

  y_max_limit <= to_unsigned (940, video_width -1);
  y_min_limit <= to_unsigned (64, video_width -1);

  c_max_limit <= to_unsigned (960, video_width -1);
  c_min_limit <= to_unsigned (64, video_width -1);

  cm_save_line <= '0';
  
  field_number <= '0';
  line_number  <= to_unsigned (21, 11);

  set_video_mode (video_mode, htot, hact, hbp, vact_f1, vact_f2, vbp_f1, vbp_f2, vtot_f1, vtot_f2, scan_mode);

  smpte_mode <= conv_std_logic_vector (video_mode,4);

  y_data <= conv_std_logic_vector (100, video_width -1);
  c_data <= conv_std_logic_vector (200, video_width -1);

  reset_fifo <= '1';
  delay (clk, 1);
  reset_fifo <= '0';

  delay (clk, 100);

  f <= '0';

  f_imp <= '1';
  not_frame_imp <= '0';

  delay (clk, 1);

  f_imp <= '0';
  not_frame_imp <= '1';

  delay (clk, 1);

  cm_save_line <= '1';
  delay (clk, 1);
  cm_save_line <= '0';

  delay (clk, 280 -79 + 2200 * 20 +60);
  
  for i in 0 to 959 loop

    y_data <= conv_std_logic_vector (i, video_width -1);
    c_data <= conv_std_logic_vector (i, video_width -1);
    delay (clk, 1);

  end loop; 

  for i in 0 to 957 loop

    y_data <= conv_std_logic_vector (i, video_width -1);
    c_data <= conv_std_logic_vector (i, video_width -1);
    delay (clk, 1);

  end loop; 

  y_data <= conv_std_logic_vector (500, video_width -1);
  c_data <= conv_std_logic_vector (600, video_width -1);
  delay (clk, 1);

  y_data <= conv_std_logic_vector (5, video_width -1);
  c_data <= conv_std_logic_vector (6, video_width -1);
  delay (clk, 1);


  y_data <= conv_std_logic_vector (100, video_width -1);
  c_data <= conv_std_logic_vector (200, video_width -1);

  delay (clk, 100);


  wait;  

end process;

end;
